class EmailMessage < ActiveRecord::Base
  validates_presence_of :subject, :message, :deliver_at
  before_save :set_string_delivery_at
  
  def set_string_delivery_at
    self.string_delivery_at = self.deliver_at.strftime("%H:%M")
  end

  def self.delay_email
    puts "does it enter the delay email?"
    t = Time.now
    @users = User.all
    @users.each do |user|
      @timezone = user.timezone
      # puts "timezone is ", @timezone
      # puts "time now in timezone is ", Time.now.in_time_zone(@timezone).strftime("%H:%M")
      # puts "time now is ", Time.now
      mailers = self.where("string_delivery_at = ?", Time.now.in_time_zone(@timezone).strftime("%H:%M"))
      # puts "boolean is: ", mailers.present?
      if mailers.present?
        # puts "enters!!!!!!!"
        users = User.confirmed
        mailers.each do |mailer|
          users.each do |user|
            @profile = Profile.find_by user_id: user.id
            # puts "enters user loop!"
            if @profile.daily_email_reminder
              # puts "enters delay email"
              DailyMailer.send_mail(user.email, mailer.subject, mailer.message).deliver
            end
          end
        end
      end
    end
    # puts "time in timezone is ", Time.now.in_time_zone(current_user.time_zone)
    # puts "browser timezone is ", current_user.time_zone
    # puts "time zone name is ", Time.zone.name
    # puts "time now in the current time zone is ", Time.zone.now
    # puts "local time", Time.now.localtime
    # puts "time now with strftime", Time.now.strftime("%H:%M")
    # puts "time is ", t.getlocal.strftime("%H:%M")
    # puts "time now is ", t.strftime("%H:%M")
    # mailers = self.where("string_delivery_at = ?", Time.now.strftime("%H:%M"))
    # puts "boolean is: ", mailers.present?
    # if mailers.present?
    #   puts "enters!!!!!!!"
    #   users = User.confirmed
    #   mailers.each do |mailer|
    #     users.each do |user|
    #       @profile = Profile.find_by user_id: user.id
    #       puts "enters user loop!"
    #       if @profile.daily_email_reminder
    #         puts "enters delay email"
    #         DailyMailer.send_mail(user.email, mailer.subject, mailer.message).deliver
    #       end
    #     end
    #   end
    # end
  end
end
