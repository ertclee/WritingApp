require 'rails_helper'

feature 'Show a word count graph' do

  context 'as a loggedin user' do
    background do
      email = 'stevn1202@gmail.com'
      password = 'test1234'
      @user = User.create(:email => email, :password => password)

      log_in_user
    end

    def log_in_user(email = 'stevn1202@gmail.com', password = 'test1234')
      reset_session!
      visit user_session_path
      fill_in 'Email', :with => email
      fill_in 'Password', :with => password
      click_button 'Login'
    end
  end
end
