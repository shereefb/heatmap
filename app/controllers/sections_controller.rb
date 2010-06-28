class SectionsController < ApplicationController
  before_filter :require_user, :except => :show
  before_filter :find_survey
  before_filter :find_section, :except => [:new, :create]
  before_filter :authorize_survey, :except => [:show]
  before_filter :authorize_section, :except => [:new, :create]
  
  
  def new
    @section = Section.new
  end
  
  def create
    @section = @survey.sections.build(params[:section])
    
    logger.info("what what")
    if @section.save
      flash[:success] = 'Section added'
      redirect_to survey_url(@survey)
    else
      logger.info("failed")
      render :new
    end
  end
    
  def show
    logger.info("section #{@section}")
    @question = Question.new
    @questions = @section.questions
  end
  
  def edit
  end
  
  def update
    if @section.update_attributes(params[:section])
      flash[:success] = 'Section updated'
      redirect_to survey_section_url(@survey, @section)
    else
      render :edit
    end
  end
  
end
