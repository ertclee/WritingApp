desc "Send the daily email"
task :send_daily_email => :environment do
	until 2 < 1 do
		puts 'start!!'
		EmailMessage.delay_email
		puts 'done!!'
		sleep 3600
	end
end
