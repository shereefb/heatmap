class QuestionsController < ApplicationController
  before_filter :require_user, :except => :show
  before_filter :find_survey
  before_filter :find_section
  before_filter :find_question, :except => [:new, :create]
  before_filter :authorize_survey, :except => [:show]

  def new
    @question = Question.create_with_default_values params[:variation], {:section_id => @section.id}
    # @question.section = @section
    # @question.variation = 
    # @question.create_with_default_values 

    if @question
      flash[:success] = 'Question added'
      redirect_to edit_survey_section_question_url(@survey, @section, @question)
    else
      flash[:success] = 'Failed to create question'
      render :new
    end
    
  end

  # def create
  #   @question = @section.questions.build(params[:question])
  #   
  #   if @question.save
  #     flash[:success] = 'Question added'
  #     redirect_to survey_section_url(@survey, @section)
  #   else
  #     render :new
  #   end
  # end
  #   
  def show
  end
  
  def edit
    @response_set = ResponseSet.dummy
  end
  
  def update
    @question.default_args
    if @question.update_attributes(params[:question])
      flash[:success] = 'Question updated'
      respond_to do |format|
        format.js do
          render :update do |page|
            @response_set = ResponseSet.dummy
            @question.reload
            page.replace_html "question_preview", :partial => 'partials/question', :locals => {:question => @question, :response_set => @response_set}
            page.visual_effect :highlight, "question_preview", :duration => 3
          end
        end
        format.html {redirect_to edit_survey_section_question_url(@survey, @section, @question)}
      end
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
