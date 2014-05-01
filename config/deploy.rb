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
HAPROXY_CONFIG = ERB.new(File.read("config/haproxy.config.erb")).result

set :domain,        'torrero-main'
set :deploy_to,     '/home/ubuntu/torrero-main'
set :repository,    'https://github.com/otobrglez/torrero.git'
set :branch,        'master'
set :forward_agent, true
set :keep_releases, 2

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['log', 'tors']

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
namespace :torrero do

  desc "Start everything (Tors, Privoxys and HAProxy)"
  task :start do
    invoke :'tor:start_all'
    invoke :'haproxy:start'
  end

end

namespace :tor do
  desc "Dump configuration"
  task :config do
    require "pp"
    pp TORRERO_CONFIG
  end

  desc "Start Tors"
  task :start_all do
    invoke :'privoxy:update'

    TORRERO_CONFIG["tors"].each do |t, params|

      # Start Tor as daemon
      cli_params = params.to_a.map {|k,v| "--#{k} #{v} \\\n" }.join(" ")
      cmd = "tor #{cli_params} --Log 'notice file ~/torrero-main/shared/log/#{t}.log'"

      # Start Privoxy
      cmd_2 = "privoxy --pidfile ~/torrero-main/shared/pids/privoxy-%s.pid ~/torrero-main/shared/config/privoxy-%s.config" % [t,t]

      queue %[#{cmd}]
      queue %[#{cmd_2}]
    end

    invoke :'haproxy:update'
  end

  desc "Stop Tors"
  task :stop_all do
    queue %[cat #{deploy_to}/shared/pids/t-*.pid | xargs kill -s SIGINT]
    queue %[cat #{deploy_to}/shared/pids/privoxy-*.pid | xargs kill -s SIGINT]

  end

  desc "Cat logs from Tors"
  task :logs do
    queue %[cat #{deploy_to}/shared/log/t-*.log]
  end

end

namespace :haproxy do

  desc "Dump configuration"
  task :config do
    require "pp"
    puts HAPROXY_CONFIG
  end

  desc "Start HAProxy"
  task :start do
    invoke :'haproxy:update'
    cmd = "haproxy -f #{TORRERO_CONFIG['haproxy']['config']} -p #{TORRERO_CONFIG['haproxy']['pid']} -D"
    queue cmd
  end

  desc "Stop HAProxy"
  task :stop do
    #TODO: Not the right signal
    queue %[cat #{TORRERO_CONFIG['haproxy']['pid']} | xargs kill -s SIGINT]
  end

  desc "Update HAProxy configuration for Tors"
  task :update do
    queue %[echo "#{HAPROXY_CONFIG}" > #{TORRERO_CONFIG['haproxy']['config']}]
  end

end

namespace :privoxy do

  desc "Update Privoxy configuration"
  task :update do
    i = 0
    TORRERO_CONFIG["tors"].each do |tor, params|
      config = ERB.new(File.read("config/privoxy.config.erb")).result(binding)
      cmd = %[echo "#{config}" > ~/torrero-main/shared/config/privoxy-%s.config] % tor
      queue cmd

      i = i + 1
    end
  end

end



