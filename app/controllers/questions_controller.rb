class QuestionsController < ApplicationController
  before_filter :require_user, :except => :show
  before_filter :find_survey
  before_filter :find_section
  before_filter :find_question, :except => [:new, :create, :select]
  before_filter :authorize_survey, :except => [:show]

  def new
    @question = Question.create_with_default_values params[:variation], {:section_id => @section.id}
    
    if @question
      @response_set = ResponseSet.dummy
      
      respond_to do |wants|
        wants.js do
          flash[:success] = 'Question added'
          render :update do |page|
            if @question.part_of_group?
              page.replace_html "question_edit", :partial => 'edit', :locals => {:survey => @survey, :section => @section, :question => @question} 
              page.replace_html "question_preview", :partial => 'partials/question_group', :locals => {:question_group => @question_group, :group_questions => @question_group.questions, :response_set => @response_set}
            else
              page.replace_html "question_preview", :partial => 'partials/question', :locals => {:question => @question, :response_set => @response_set}
              page.replace_html "question_edit_container_#{@question.id}", :partial => 'edit', :locals => {:survey => @survey, :section => @section, :question => @question} 
            end
              page.call "close_fancybox"
          end
        end
      end
      # redirect_to edit_survey_section_question_url(@survey, @section, @question)
    else
      flash[:success] = 'Failed to create question'
      render :new
    end
    
  end
  
  def select
    render :layout => :blank
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
    respond_to do |wants|
      wants.js do
        render :update do |page|
          page.replace_html "question_edit_container_#{@question.id}", :partial => 'edit', :locals => {:survey => @survey, :section => @section, :question => @question} 
        end
      end
    end
  end
  
  def update
    logger.info("question: #{@question.inspect} #{@question.part_of_group?}")
    if @question.part_of_group?
      @question_group = @question.question_group
      success = @question_group.update_attributes(params[:question_group])
      @question = @question_group.questions.first
    else
      @question.default_args
      success = @question.update_attributes(params[:question])
    end
    if success
      respond_to do |format|
        format.js do
          render :update do |page|
            @response_set = ResponseSet.dummy
            if @question.part_of_group?
              @question_group.reload
              page.replace_html "question_edit", :partial => 'edit', :locals => {:survey => @survey, :section => @section, :question => @question} 
              page.replace_html "question_preview", :partial => 'partials/question_group', :locals => {:question_group => @question_group, :group_questions => @question_group.questions, :response_set => @response_set}
            else
              @question.reload
              page.replace_html "question_preview", :partial => 'partials/question', :locals => {:question => @question, :response_set => @response_set}
            end
            page.visual_effect :highlight, "question_preview", :duration => 3
            page.call "growl", "Question updated successfully"
          end
        end
        format.html do
          flash[:success] = 'Question updated'
          redirect_to edit_survey_section_question_url(@survey, @section, @question)
        end
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
