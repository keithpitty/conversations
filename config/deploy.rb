set :application, "conversations"
set :repository,  "http://svn.keithpitty.com/#{application}/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "localhost"
role :web, "localhost"
role :db,  "localhost", :primary => true

set :user, "keithpitty"
set :runner, "keithpitty"
set :scm_command, "/usr/local/bin/svn"
set :rake, "/usr/local/bin/rake"

# Copy database and environment config files

desc "Copy production database and environment config files."
namespace :deploy do
  task :after_update_code, :roles => :app do
    db_config = "#{shared_path}/config/database.yml.production"
    env_config = "#{shared_path}/config/environment.rb.production"
    run "cp #{db_config} #{release_path}/config/database.yml"
    run "cp #{env_config} #{release_path}/config/environment.rb"
  end  
end