require "bundler/capistrano"
require "capistrano-rbenv"
require "capistrano-unicorn"

set :rbenv_ruby_version, "1.9.3-p392"

server = ENV['CAP_SERVER']

#default_run_options[:pty] = true

set :application, "coderetreat-mx"
set :repository,  "git@github.com:railsmx/coderetreat-mx.git"
set :user, "www"
set :deploy_to, "/home/www/coderetreat"
set :use_sudo, false
set :bundle_flags, "--deployment --quiet --binstubs"
set :rails_env, "production"
set :normalize_asset_timestamps, false

role :web, server
role :app, server
role :db,  server, :primary => true

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

before "deploy:restart", "deploy:assets"
after 'deploy:restart', 'unicorn:reload' # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'  # app preloaded
