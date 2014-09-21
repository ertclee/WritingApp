set :output, "#{path}/log/cron.log"

every 1.minute do
  runner "EmailMessage.delay_email", environment: 'development'
 
end
