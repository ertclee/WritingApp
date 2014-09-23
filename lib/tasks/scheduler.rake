desc "Update the crontab file"
task :update_crontab => :environment do
	run "cd #{release_path} && whenever --update-crontab #{application}"
end
