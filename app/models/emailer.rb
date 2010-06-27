class Emailer < ActionMailer::Base
  def password_reset_instructions(user)
    setup_email
    subject '[Surveydoo] Password Reset Instructions'
    recipients user.email
    body :user => user
  end
  
  private
  
  def setup_email
    from    %("Surveydoo" <noreply@surveydoo.com>)
    sent_on Time.current
  end
end