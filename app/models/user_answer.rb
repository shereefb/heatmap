# # == Schema Information
# #
# # Table name: user_answers
# #
# #  id          :integer         not null, primary key
# #  user_id     :integer
# #  question_id :integer
# #  answer_id   :integer
# #  correct     :boolean
# #  created_at  :datetime
# #  updated_at  :datetime
# #
# 
# class UserAnswer < ActiveRecord::Base
#   
#   attr_accessible
#   
#   belongs_to :user
#   belongs_to :question
#   belongs_to :answer
#   
#   validates_presence_of :user_id,
#                         :question_id,
#                         :answer_id
#                         
#   validates_uniqueness_of :user_id, :scope => :question_id,
#                                     :message => 'has already answered this question'
#   
#   validate :user_cannot_be_quiz_owner
#   validate :user_must_be_participating_in_quiz
#   validate :question_approved
#   
#   before_create :set_correct                             
#   after_create :update_correct_or_incorrect_count
#   
#   named_scope :correct, :conditions => {:correct => true}
#   
#   private
#   
#   def set_correct
#     self.correct = true if question.correct_answer == answer
#   end
#   
#   def update_correct_or_incorrect_count
#     if participation = user.find_participation(question.quiz)
#       count_field = correct? ? :correct_count : :incorrect_count
#       participation.increment!(count_field)
#     end
#   end
#       
#   def user_cannot_be_quiz_owner
#     if question and user and question.quiz.owner == user
#       errors.add_to_base('You cannot answer a question in your own quiz')
#     end
#   end
#   
#   def user_must_be_participating_in_quiz
#     if question and user and not user.participating?(question.quiz)
#       errors.add_to_base('You must be participating in this quiz to answer questions')
#     end
#   end
#   
#   def question_approved
#     if question and not question.approved?
#       errors.add_to_base('Question must be approved')
#     end
#   end
# end
