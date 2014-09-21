class DailyMailer < ActionMailer::Base
  default from: "writersmob@gmail.com"
  
  def send_mail(email, subject, body)
    @body = body
    mail(:to => email, :subject => subject) do |format|
      format.html
    end
  end

end
