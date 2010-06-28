class QuestionsController < ApplicationController
  before_filter :require_user, :except => :show
  before_filter :find_survey
  before_filter :find_section
  before_filter :find_question, :except => [:new, :create]
  before_filter :authorize_survey, :except => [:show]
  # 
  # def suggest
  #   @question = Question.new :suggester_id => current_user.id
  # end
  # 
  def new
    @question = Question.new
  end

  def create
    @question = @section.questions.build(params[:question])
    
    if @question.save
      flash[:success] = 'Question added'
      redirect_to survey_section_url(@survey, @section)
    else
      render :new
    end
  end
    
  def show
  end
  
  def edit
  end
  
  def update
    if @question.update_attributes(params[:question])
      flash[:success] = 'Question updated'
      redirect_to survey_section_url(@survey, @section)
    else
      render :edit
    end
  end
  # 
  # def approve
  #   access_denied! unless current_user.questions.include?(@question)
  #   @question.update_attribute(:approved, true)
  #   flash[:success] = 'Question approved'
  #   redirect_to survey_question_url(@question.survey, @question)
  # end
end
