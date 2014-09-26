desc "Send the daily email"
task :send_daily_email => :environment do
	i = 0 
	until 2 < 1 do
		puts 'enters scheduler ', i
		EmailMessage.delay_email
		i += 1
		puts 'done'
	end
end
