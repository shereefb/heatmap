# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  
  THE_DOMAIN = 'http://surveydoo.com'
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation
  
  class AccessDenied < StandardError; end
  
  rescue_from AccessDenied do |exception|
    flash[:failure] = exception.message
    redirect_to root_url
  end
  
  helper_method :current_user_session,
                :current_user,
                :owner?,
                :suggester?,
                :participant?
  
  before_filter :ensure_domain

  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:failure] = 'Please login'
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:failure] = 'Please logout'
      redirect_to root_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def owner?
    return false unless current_user
    @survey.user == current_user
  end
  
  def suggester?
    return false unless current_user
    @question.try(:suggester) == current_user
  end
  
  def participant?
    return false unless current_user
    not owner? and not suggester?
  end
  
  def find_survey
    @survey = Survey.find(params[:survey_id] || params[:id])
  end
  
  def find_question
    question_id = params[:question_id] || params[:id]
    question_scope = @survey.try(:questions) || Question
    @question = question_scope.find(question_id)
  end
  
  def authorize_survey
      access_denied! unless current_user && current_user.can_edit_survey?(@survey)
  end
  
  def authorize_question
    access_denied! unless current_user.can_edit_question?(@question)
  end
  
  def access_denied!(message = 'Access denied')
    raise AccessDenied, message
  end
  
  def ensure_domain
    if request.subdomains.first.eql?('www')
      redirect_to THE_DOMAIN
    end
  end
end
