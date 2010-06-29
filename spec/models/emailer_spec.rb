require 'spec_helper'

describe Emailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include ActionController::UrlWriter
  
  describe '#password_reset_instructions' do    
    before do
      @user = users(:justin)
      @email = Emailer.create_password_reset_instructions(@user)
    end
    
    it { @email.should deliver_from("PsychSurveys <noreply@PsychSurveys.com>") }
    it { @email.should deliver_to(@user.email) }
    it { @email.should have_subject('[PsychSurveys] Password Reset Instructions') }
    
    it 'should contain the password reset link' do
      url = edit_password_reset_url @user.perishable_token,
                                    :host => 'PsychSurveys.com',
                                    :protocol => 'http'
      
      @email.should have_body_text(url)
    end
  end
end