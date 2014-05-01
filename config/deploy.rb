require 'erb'
require 'yaml'
require 'mina/bundler'
# require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)
# require 'mina_sidekiq/tasks'
# require 'mina-stack'
# require 'mina-contrib/helpers'
require 'dotenv'

Dotenv.load

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

TORRERO_CONFIG = YAML.load(ERB.new(File.read("config/torrero.yml")).result)

set :domain,        'torrero-main'
set :deploy_to,     '/home/ubuntu/torrero-main'
set :repository,    'https://github.com/otobrglez/torrero.git'
set :branch,        'master'
set :forward_agent, true
set :keep_releases, 2

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['log']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-2.1.1@torrero]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/tors"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tors"]

  queue! %[mkdir -p "#{deploy_to}/shared/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/pids"]

  # queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  # queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    # invoke :'rails:db_migrate'
    # invoke :'rails:assets_precompile'

    to :launch do
      queue "touch #{deploy_to}/tmp/restart.txt"
    end
  end
end

## Torrero tasks ##

namespace :tor do
  desc "Dump configuration"
  task :config do
    require "pp"
    pp TORRERO_CONFIG
  end

  desc "Start tors"
  task :start_all do
    TORRERO_CONFIG["tors"].each do |t, params|
      cli_params = params.to_a.map {|k,v| "--#{k} #{v} \\\n" }.join(" ")
      cmd = "tor #{cli_params} --Log 'notice file ~/torrero-main/shared/log/#{t}.log'"
      queue! %[#{cmd}]
    end

    invoke :'haproxy:update'
  end

  desc "Stop tors"
  task :stop_all do
    queue %[cat #{deploy_to}/shared/pids/t-*.pid | xargs kill -s SIGINT]
  end

  desc "Cat logs"
  task :logs do
    queue %[cat #{deploy_to}/shared/log/t-*.log]
  end

end

namespace :haproxy do

  desc "Start HAProxy"
  task :start do
    cmd = "haproxy -f torrero-main/current/config/haproxy.config
    -p ~/torrero-main/shared/pids/haproxy.pid -D"
    puts cmd
    queue cmd
  end

  desc "Stop tors"
  task :stop do
    queue %[cat #{deploy_to}/shared/pids/haproxy.pid | xargs kill -s SIGINT]
  end

  desc "Update HAProxy config for Tors"
  task :update do

  end

end

