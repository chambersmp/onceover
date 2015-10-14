require 'controlrepo/class'
require 'controlrepo/node'
require 'controlrepo/group'
require 'controlrepo/test'

class Controlrepo
  class TestConfig
    require 'yaml'

    attr_accessor :classes
    attr_accessor :nodes
    attr_accessor :groups
    attr_accessor :tests

    def initialize(file)
      begin
        config = YAML.load(File.read(file))
      rescue YAML::ParserError
        raise "Could not parse the YAML file, check that it is valid YAML and that the encoding is correct"
      end

      @classes =[]
      @nodes =[]
      @groups =[]
      @tests = []
      
      config['classes'].each { |clarse| @classes << Controlrepo::Class.new(clarse) }
      config['nodes'].each { |node| @nodes << Controlrepo::Node.new(node) }
      config['groups'].each { |name, members| @groups << Controlrepo::Group.new(name, members) }

      # Add the 'all_classes' and 'all_nodes' default groups
      @groups << Controlrepo::Group.new('all_nodes',@nodes)
      @groups << Controlrepo::Group.new('all_classes',@classes)

      config['test_matrix'].each do |machines, roles|
        @tests << Controlrepo::Test.new(machines,roles)
      end
    end

    def r10k_deploy_local(repo = Controlrepo.new)
      require 'controlrepo'
      tempdir = Dir.mktmpdir('r10k')
      repo.tempdir = tempdir

      # Read in the config and change all the directories, then create them
      r10k_config = repo.r10k_config
      r10k_config[:cachedir] = "#{tempdir}#{r10k_config[:cachedir]}"
      FileUtils::mkdir_p(r10k_config[:cachedir])
      r10k_config[:sources].map do |name,source_settings|
        source_settings["basedir"] = "#{tempdir}#{source_settings["basedir"]}"
        FileUtils::mkdir_p(source_settings["basedir"])
        # Yes, I realise this is going to set it many times
        repo.temp_environmentpath = source_settings["basedir"]
      end
      File.write("#{tempdir}/r10k.yaml",r10k_config.to_yaml)

      # Pull the trigger!
      Dir.chdir(tempdir) do
        `r10k deploy environment -p --color --config #{tempdir}/r10k.yaml --verbose`
      end

      # Return tempdir for use
      tempdir
    end

    def write_spec_test(location, test)
      # Use an ERB template to write a spec test
      template_dir = File.expand_path('../../templates',File.dirname(__FILE__))
      spec_template = File.read(File.expand_path('./test_spec.rb.erb',template_dir))
      output_file = Tempfile.new(['test','_spec.rb'],location)
      File.write(output_file,ERB.new(spec_template, nil, '-').result(binding))
      output_file
    end

    def write_rakefile(location, pattern)
      template_dir = File.expand_path('../../templates',File.dirname(__FILE__))
      rakefile_template = File.read(File.expand_path('./Rakefile.erb',template_dir))
      File.write("#{location}/Rakefile",ERB.new(rakefile_template, nil, '-').result(binding))
    end

    # TODO: allow this to accept an environment, probably re run the whole thing with a
    # different environment
    def write_spec_helper(location, repo)
      environmentpath = repo.temp_environmentpath
      modulepath = repo.config['modulepath']
      modulepath.delete("$basemodulepath")
      modulepath.map! do |path|
        "#{environmentpath}/production/#{path}"
      end
      modulepath = modulepath.join(":")
      hiera_yaml = "#{environmentpath}/production/hiera.yaml"

       # Use an ERB template to write a spec test
      template_dir = File.expand_path('../../templates',File.dirname(__FILE__))
      spec_helper_template = File.read(File.expand_path('./spec_helper.rb.erb',template_dir))
      File.write("#{location}/spec_helper.rb",ERB.new(spec_helper_template, nil, '-').result(binding))
    end


    def run_tests(repo)
      require 'puppetlabs_spec_helper/puppet_spec_helper'
      require 'rspec-puppet'

      RSpec.configure do |c|
        c.hiera_config = repo.hiera_config_file
        c.environmentpath = repo.temp_environmentpath
      end

      binding.pry
    end
  end
end