class UserAnswersController < ApplicationController
  # before_filter :require_user
  # before_filter :find_quiz, :except => :destroy
  # before_filter :find_question, :except => :destroy
  # 
  # def create
  #   current_user.answer_question!(@question, params)
  # rescue ActiveRecord::RecordInvalid => invalid
  #   flash[:failure] = invalid.record.error_sentence
  # rescue ActiveRecord::RecordNotFound
  #   flash[:failure] = 'Quiz, Question or Answer could not be found'
  # ensure
  #   redirect_to quiz_question_url(@quiz, @question)
  # end
  # 
  # def destroy
  #   user_answer = current_user.answers.find(params[:id])
  #   user_answer.destroy
  #   redirect_to quiz_question_url user_answer.question.quiz,
  #                                 user_answer.question
  # rescue ActiveRecord::RecordNotFound
  #   flash[:failure] = 'Answer could not be found'
  #   redirect_to root_url
  # end
end
