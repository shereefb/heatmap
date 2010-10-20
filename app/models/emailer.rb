class Emailer < ActionMailer::Base
  def password_reset_instructions(user)
    setup_email
    subject '[VideoHeatMap] Password Reset Instructions'
    recipients user.email
    body :user => user
  end
  
  private
  
  def setup_email
    from    %("VideoHeatMap" <noreply@VideoHeatMap.com>)
    sent_on Time.current
  end
end