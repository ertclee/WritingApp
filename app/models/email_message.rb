class EmailMessage < ActiveRecord::Base
  validates_presence_of :subject, :message, :deliver_at
  before_save :set_string_delivery_at
  
  def set_string_delivery_at
    self.string_delivery_at = self.deliver_at.strftime("%H:%M")
  end
  
  def self.delay_email
    mailers = self.where("string_delivery_at = ?", Time.now.strftime("%H:%M"))
    if mailers.present?
      puts "enters!!!!!!!"
      users = User.confirmed
      mailers.each do |mailer|
        users.each do |user|
          @profile = Profile.find_by user_id: user.id
          puts "enters user loop!"
          if @profile.daily_email_reminder
            puts "enters delay email"
            DailyMailer.send_mail(user.email, mailer.subject, mailer.message).deliver
          end
        end
      end
    end
  end
end
