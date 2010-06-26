# class QuizzesController < ApplicationController
#   before_filter :require_user, :except => [:index, :show]
#   before_filter :find_quiz, :except => [:index, :new, :create]
#   before_filter :authorize_quiz, :only => [:edit, :update]
#   before_filter :find_participation, :only => :show
#   after_filter :touch_quiz, :only => :show
#   
#   def index
#     @quizzes = Quiz.all
#   end
#   
#   def new
#     @quiz = Quiz.new
#   end
#   
#   def create
#     @quiz = Quiz.new(params[:quiz])
#     @quiz.owner = current_user
#     
#     if @quiz.save
#       redirect_to @quiz
#     else
#       render :new
#     end
#   end
#   
#   def edit
#   end
#   
#   def update
#     if @quiz.update_attributes(params[:quiz])
#       redirect_to @quiz
#     else
#       render :edit
#     end
#   end
#   
#   def show
#     @participating_users = @quiz.participants
#     @questions = @quiz.questions
#   end
#   
#   def participate
#     current_user.participate!(@quiz)
#     flash[:success] = 'You are now participating in this quiz'
#   rescue ActiveRecord::RecordInvalid => invalid
#     flash[:failure] = invalid.record.error_sentence
#   ensure
#     redirect_to @quiz
#   end
#   
#   private
#   
#   def find_participation
#     if current_user and not owner?
#       @participation = current_user.find_participation(@quiz)
#     end
#   end
#   
#   def touch_quiz
#     @quiz.touch(:last_viewed) unless owner?
#   end
# end
