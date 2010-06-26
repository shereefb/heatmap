# class QuestionsController < ApplicationController
#   before_filter :require_user, :except => :show
#   before_filter :find_quiz, :except => :approve
#   before_filter :find_question, :except => [:suggest, :new, :create]
#   before_filter :authorize_quiz, :except => [:suggest, :show, :approve]
#   before_filter :authorize_question, :except => [:show, :suggest, :approve, :new, :create]
#   
#   def suggest
#     @question = Question.new :suggester_id => current_user.id
#   end
#   
#   def new
#     @question = Question.new
#   end
#   
#   def create
#     @question = @quiz.questions.build(params[:question])
#     @question.approved = true if @quiz.owner == current_user
#     
#     if @question.save
#       redirect_to quiz_question_url(@quiz, @question)
#     else
#       render :new
#     end
#   end
#     
#   def show
#     @answer = Answer.new
#     @answers = @question.answers
#     
#     if participant?
#       @user_answer = current_user.answers.find_or_initialize_by_question_id(@question)
#       @total_answered = current_user.total_answered(@quiz)
#       @total_questions = @quiz.questions.count
#       @participation = current_user.find_participation(@quiz)
#     elsif suggester?
#       @suggested_questions = current_user.suggested_questions_for_quiz(@quiz)
#     end
#   end
#   
#   def edit
#   end
#   
#   def update
#     if @question.update_attributes(params[:question])
#       redirect_to quiz_question_url(@quiz, @question)
#     else
#       render :edit
#     end
#   end
#   
#   def approve
#     access_denied! unless current_user.questions.include?(@question)
#     @question.update_attribute(:approved, true)
#     flash[:success] = 'Question approved'
#     redirect_to quiz_question_url(@question.quiz, @question)
#   end
# end
