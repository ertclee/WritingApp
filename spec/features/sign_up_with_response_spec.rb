require 'rails_helper'

feature 'Sign up after saving a response' do
  before do
    @challenge = create(:writing_challenge)
    @user = build(:user)
  end

  scenario 'Registered user should see his response' do
    give_response('Response 1 from visitor')
    register
    confirm_account
    complete_registration
    expect(page).to have_content @challenge.exercise
    expect(page).to have_content 'Response 1 from visitor'
  end
end

def give_response(response)
  visit root_path
  fill_in 'response_response', with: response
  click_button 'Complete'
  expect(page).to have_content 'Great job!'
end

def register
  fill_in 'user_email', with: @user.email
  click_button 'Register'
  expect(page).to have_content 'Please, check your email for registration details.'
end

def confirm_account
  open_last_email
  visit_in_email('Confirm my account')
  expect(page).to have_content 'Complete your registration.'
end

def complete_registration
  fill_in 'user_name', with: @user.name
  fill_in 'user_password', with: '123456'
  fill_in 'user_password_confirmation', with: '123456'
  click_button 'Confirm account'
end
