require "bundler/capistrano"
require "capistrano-rbenv"

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

thin_options = " -d -P #{shared_path}/pids/thin.pid -e production"
namespace :thin do
  [:start, :stop, :restart].each do |action|
    task action do
      run "cd #{current_path} && #{current_path}/bin/thin #{action} #{thin_options}"
    end
  end
end

namespace :deploy do
  task :assets do
    run "cd #{current_path} && #{current_path}/bin/rake assets:precompile"
  end
end

before "deploy:restart", "deploy:assets"
after "deploy:restart", "thin:restart"
