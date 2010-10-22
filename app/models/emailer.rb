class Emailer < ActionMailer::Base
  def password_reset_instructions(user)
    setup_email
    subject '[videoheatmaps] Password Reset Instructions'
    recipients user.email
    body :user => user
  end
  
  private
  
  def setup_email
    from    %("videoheatmaps" <noreply@videoheatmaps.com>)
    sent_on Time.current
  end
end