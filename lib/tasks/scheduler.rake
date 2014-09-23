desc "Update the crontab file"
task :send_daily_email => :environment do
	EmailMessage.delay_email
end
