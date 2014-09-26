desc "Send the daily email"
task :send_daily_email => :environment do
	until 2 < 1 do
		puts 'enters scheduler'
		EmailMessage.delay_email
		puts 'done'
	end
end
