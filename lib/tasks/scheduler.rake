desc "Send the daily email"
task :send_daily_email => :environment do
	puts 'enters scheduler'
	EmailMessage.delay_email
	puts 'done'
end
