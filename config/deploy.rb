set :application, "f_loss"
set :repository,  "."

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/vhosts/amffunds.com/subdomains/docs/httpdocs/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
default_run_options[:pty] = true 
set :use_sudo, false
set :user, 'asarx123'
set :admin_runner, 'root'

set :scm, :git
set :deploy_via, :copy

set :copy_remote_dir, "/var/tmp"

role :app, "docs.amffunds.com"
role :web, "docs.amffunds.com"
role :db,  "docs.amffunds.com", :primary => true



    namespace :deploy do
      desc "Restart Application" 
      task :restart, :roles => :app do
        run "touch #{current_path}/tmp/restart.txt" 
      end
      desc "Start Application -- not needed for Passenger" 
      task :start, :roles => :app do
        # nothing -- need to override default cap start task when using Passenger
      end
    end