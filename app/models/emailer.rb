class Emailer < ActionMailer::Base
  def password_reset_instructions(user)
    setup_email
    subject '[PsychSurveys] Password Reset Instructions'
    recipients user.email
    body :user => user
  end
  
  private
  
  def setup_email
    from    %("PsychSurveys" <noreply@PsychSurveys.com>)
    sent_on Time.current
  end
end