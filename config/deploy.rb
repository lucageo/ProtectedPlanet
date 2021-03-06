# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'ProtectedPlanet'
set :repo_url, 'git@github.com:unepwcmc/ProtectedPlanet.git'

set :filter, :roles => %w{web util}

set :deploy_user, 'wcmc'
set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:application)}"


set :whenever_environment, -> { fetch(:stage) }
set :whenever_roles, [:util]

set :migration_role, :util




set :rvm_type, :user
set :rvm_ruby_version, '2.1.3'

set :pty, true


set :ssh_options, {
  forward_agent: true,
}

set :linked_files, %w{config/database.yml .env}

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/.well-known')

set :keep_releases, 5

set :passenger_roles, :web
