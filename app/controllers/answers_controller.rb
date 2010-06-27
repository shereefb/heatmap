class AnswersController < ApplicationController
  before_filter :require_user
  before_filter :find_survey, :only => :create
  before_filter :find_question, :only => :create
  before_filter :authorize_survey, :only => :create
  before_filter :authorize_question, :only => :create
  before_filter :find_answer, :except => :create
  
  def create
    @answer = @question.answers.build(params[:answer])
    
    if @answer.save
      flash[:success] = 'Answer saved'
    else
      flash[:failure] = @answer.error_sentence
    end
    
    redirect_to survey_question_path(@survey, @question)
  end
  
  def edit
    respond_to do |format|
      format.js do
        render :partial => 'edit.html.haml'
      end
    end
  end
  
  def update
    respond_to do |format|
      format.js do
        if @answer.update_attributes(params[:answer])
          render :partial => 'answer.html.haml', :locals => {:answer => @answer}
        else
          render :text => @answer.error_sentence, :status => :unprocessable_entity
        end
      end
    end
  end
  
  def show
    respond_to do |format|
      format.js do
        render :partial => 'answer.html.haml', :locals => {:answer => @answer}
      end
    end
  end
  
  def destroy
    respond_to do |format|
      format.js do
        @answer.destroy
        render :nothing => true
      end
    end
  end
    
  private
  
  def find_answer
    @answer = Answer.find(params[:id])
    access_denied! unless current_user.can_edit_answer?(@answer)
  end
end
