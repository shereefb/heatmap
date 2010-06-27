class Participation < ActiveRecord::Base
  
  # attr_accessible
  # 
  # belongs_to :user
  # belongs_to :survey, :counter_cache => true
  # 
  # validates_presence_of :user_id,
  #                       :survey_id
  #                       
  # validates_uniqueness_of :survey_id, :scope => :user_id,
  #                                   :message => 'is already part of your participation list'
  #                                   
  # validate :user_cannot_be_survey_owner
  # 
  # after_destroy :remove_user_answers
  # 
  # private
  # 
  # def user_cannot_be_survey_owner
  #   if survey and user and survey.owner == user
  #     errors.add_to_base('You cannot participate in your own survey')
  #   end
  # end
  # 
  # def remove_user_answers
  #   UserAnswer.destroy_all :user_id => user.id,
  #                          :question_id => survey.question_ids
  # end
end

# == Schema Information
#
# Table name: participations
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  quiz_id         :integer
#  correct_count   :integer         default(0)
#  incorrect_count :integer         default(0)
#  created_at      :datetime
#  updated_at      :datetime
#

