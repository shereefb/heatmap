class SurveysController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  before_filter :find_survey, :except => [:index, :new, :create]
  before_filter :authorize_survey, :except => [:new, :create, :index]
  
  def index
    @surveys = Survey.all
  end
  
  def new
    @survey = Survey.new
  end
  
  def create
    @survey = Survey.new(params[:survey])
    @survey.user = current_user
    
    if @survey.save
      redirect_to @survey
    else
      render :new
    end
  end
  # 
  # def edit
  # end
  # 
  # def update
  #   if @survey.update_attributes(params[:survey])
  #     redirect_to @survey
  #   else
  #     render :edit
  #   end
  # end
  # 
  # def show
  #   @participating_users = @survey.participants
  #   @questions = @survey.questions
  # end
  # 
  
  # private
  # 
  # def find_survey
  #   @survey = Survey.find(params[:id])
  # end
  
end
