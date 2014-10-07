class SubmitWritingChallengeMailer < ActionMailer::Base
	def submission_email(mail)
		@body =  mail.exercise
	 	mail(from: mail.email, to: "writersmob@gmail.com", subject: 'User submitted writing challenge')
	end
end
