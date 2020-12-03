require "rvm1/capistrano3"
require_relative "deploy/aws_utils"
# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :whenever_identifier, ->{"#{fetch :application}_#{fetch :stage}"}

set :application, "base-rails6-ruby2.7"
set :repo_url, "git@github.com:khuongnt-0294/base-rails6-ruby2.7.git"
set :deploy_to, "/usr/local/rails_apps/base-rails6-ruby2.7"
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
 
set :default_stage, "production"
set :scm, :git
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :deploy_via, :remote_cache

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto
set :format, :pretty
set :log_level, :debug

set :rvm_type, :system
set :rvm1_ruby_version, "2.7.1"
set :deploy_ref, ENV["DEPLOY_REF"]
set :deploy_ref_type, ENV["DEPLOY_REF_TYPE"]
set :instances, get_ec2_targets unless ENV["LOCAL_DEPLOY"]
if fetch(:stage) == :production
  set :sidekiq_role, :batch
  set :whenever_roles, :batch
  set :assets_roles, :app
  set :migration_role, :app

  if fetch(:deploy_ref)
    set :branch, fetch(:deploy_ref)
  else
    raise "Please set $DEPLOY_REF"
  end
end


# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :pid_file, "#{shared_path}/tmp/pids/unicorn.pid"

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke "unicorn:restart"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, "cache:clear"
      # end
    end
  end
  desc "Upload database.yml"
  task :upload do
    on roles(:app) do |host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!("config/database.yml", "#{shared_path}/config/database.yml")
    end
  end
  before :starting, 'deploy:upload'

  desc "update ec2 tags"
  task :update_ec2_tags do
    on roles(:app) do
      within "#{release_path}" do
        branch = fetch(:branch)
        ref_type = fetch(:deploy_ref_type)
        last_commit = ref_type == 'branch' ? `git rev-parse #{branch.split('/')[1]}` : `git rev-list -n 1 #{branch}`
        update_ec2_tags ref_type, branch, last_commit if fetch(:stage) == :production  || !ENV["LOCAL_CARRIERWAVE"]
      end
    end
  end

  if fetch(:stage) == :production
    after :restart, :update_ec2_tags
  end  
end