# require 'rails_helper'

# feature 'Schedule Email Messages' do
#   scenario 'Guests cannot create email messages' do
#     visit root_path
#     expect(page).to_not have_link 'New Email Message'
#   end

#   context 'as an admin user' do
#     background do
#       email = 'admin@writersmob.com'
#       password = 'password'
#       @admin = AdminUser.create(:email => email, :password => password)

#       log_in_admin_user
#     end

#     def log_in_admin_user(email = 'admin@writersmob.com', password = 'password')
#       reset_session!
#       visit admin_root_path
#       fill_in 'Email', :with => email
#       fill_in 'Password', :with => password
#       click_button 'Login'
#     end

#     scenario 'Adding a new schedule email message' do
#       click_link 'Email Messages'
#       click_link 'New Email Message'

#       fill_in 'email_message_subject', :with => 'New Subject'
#       fill_in 'email_message_message', :with => 'This is the email body made from the Admin Interface'
#       select '%02d' % Time.now.hour, :from => "email_message_deliver_at_4i"
#       select '%02d' % Time.now.min.to_s, :from => "email_message_deliver_at_5i"
#       click_button 'Create Email message'

#       expect(page).to have_content 'New Subject'
#     end

#     context 'with an existing email message' do
#       background do
#         @email_message = EmailMessage.create(:subject => 'Test Email Subject', :message => 'Lorem ipsum dolor sit amet', :deliver_at => Time.now + 2.minutes)
#       end

#       scenario 'Editing an email message' do
#         visit admin_email_message_path(@email_message)

#         click_link 'Edit'

#         fill_in 'email_message_subject', :with => 'New Email Subject'
#         click_button 'Update Email message'

#         expect(page).to have_content 'New Email Subject'
#       end
#     end
#   end
# end
