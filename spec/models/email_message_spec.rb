# require 'rails_helper'

# describe EmailMessage do
#   describe 'validations' do
#     subject(:email_message) { EmailMessage.new } # sets the subject of this describe block
#     before { email_message.valid? }      # runs a precondition for the test/s

#     [:subject, :message, :deliver_at].each do |attribute|
#       it "should validate presence of #{attribute}" do
#         expect(email_message.errors.messages["#{attribute}".to_sym]).to include "can't be blank"      
#       end
#     end
#   end
# end
