# Plugins with the correct version
class profile::jenkins::plugins {
  $plugins = {
    'pipeline-milestone-step'          => '1.3.1',
    'pipeline-rest-api'                => '2.8',
    'handlebars'                       => '1.1.1',
    'momentjs'                         => '1.1.1',
    'pipeline-stage-view'              => '2.8',
    'pipeline-build-step'              => '2.5.1',
    'workflow-aggregator'              => '2.5',
    'pipeline-model-api'               => '1.1.8',
    'bouncycastle-api'                 => '2.16.1',
    'favorite'                         => '2.3.0',
    'jackson2-api'                     => '2.7.3',
    'github-api'                       => '1.86',
    'workflow-step-api'                => '2.12',
    'workflow-scm-step'                => '2.6',
    'pubsub-light'                     => '1.11',
    'docker-workflow'                  => '1.12',
    'ssh-credentials'                  => '1.13',
    'blueocean-config'                 => '1.1.4',
    'git-client'                       => '2.4.6',
    'scm-api'                          => '2.1.1',
    'display-url-api'                  => '2.0',
    'mailer'                           => '1.20',
    'junit'                            => '1.20',
    'script-security'                  => '1.29.1',
    'workflow-basic-steps'             => '2.6',
    'matrix-project'                   => '1.11',
    'git'                              => '3.3.2',
    'token-macro'                      => '2.1',
    'pipeline-model-definition'        => '1.1.8',
    'plain-credentials'                => '1.4',
    'sse-gateway'                      => '1.15',
    'github'                           => '1.27.0',
    'github-branch-source'             => '2.0.8',
    'blueocean-events'                 => '1.1.4',
    'ace-editor'                       => '1.1',
    'jquery-detached'                  => '1.2.1',
    'blueocean-i18n'                   => '1.1.4',
    'workflow-api'                     => '2.18',
    'variant'                          => '1.1',
    'workflow-support'                 => '2.14',
    'workflow-cps'                     => '2.36.1',
    'pipeline-input-step'              => '2.7',
    'metrics'                          => '3.1.2.10',
    'pipeline-stage-step'              => '2.2',
    'workflow-job'                     => '2.12.1',
    'credentials-binding'              => '1.12',
    'pipeline-graph-analysis'          => '1.4',
    'blueocean-commons'                => '1.1.4',
    'blueocean-web'                    => '1.1.4',
    'blueocean-rest'                   => '1.1.4',
    'cloudbees-folder'                 => '6.0.4',
    'branch-api'                       => '2.0.10',
    'blueocean-jwt'                    => '1.1.4',
    'workflow-multibranch'             => '2.16',
    'blueocean-pipeline-scm-api'       => '1.1.4',
    'docker-commons'                   => '1.8',
    'pipeline-model-extensions'        => '1.1.8',
    'git-server'                       => '1.7',
    'durable-task'                     => '1.14',
    'workflow-cps-global-lib'          => '2.8',
    'blueocean'                        => '1.1.4',
    'icon-shim'                        => '2.0.3',
    'authentication-tokens'            => '1.3',
    'workflow-durable-task-step'       => '2.12',
    'pipeline-stage-tags-metadata'     => '1.1.8',
    'pipeline-model-declarative-agent' => '1.1.1',
    'blueocean-rest-impl'              => '1.1.4',
    'blueocean-pipeline-api-impl'      => '1.1.4',
    'blueocean-github-pipeline'        => '1.1.4',
    'blueocean-git-pipeline'           => '1.1.4',
    'blueocean-personalization'        => '1.1.4',
    'blueocean-display-url'            => '2.0',
    'blueocean-pipeline-editor'        => '0.2.0',
    'blueocean-autofavorite'           => '1.0.0',
    'blueocean-dashboard'              => '1.1.4',
    'puppet-enterprise-pipeline'       => '1.3.1',
  }

  $plugins.each |$name,$version| {
    jenkins::plugin { $name:
      version => $version,
    }
  }
}
