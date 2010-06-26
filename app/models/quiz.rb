# == Schema Information
#
# Table name: quizzes
#
#  id                   :integer         not null, primary key
#  category_id          :integer
#  user_id              :integer
#  title                :string(255)
#  description          :text
#  questions_count      :integer         default(0)
#  created_at           :datetime
#  updated_at           :datetime
#  permalink            :string(255)
#  participations_count :integer         default(0)
#  questions_updated_at :datetime
#  last_viewed          :datetime
#

class Quiz < ActiveRecord::Base
  
  # attr_accessible :category_id,
  #                 :title,
  #                 :description
  # 
  # belongs_to :category, :counter_cache => true
  # belongs_to :user
  # belongs_to :owner, :class_name => 'User',
  #                    :foreign_key => 'user_id'
  # 
  # has_many :questions, :order => 'questions.number ASC',
  #                      :dependent => :destroy
  #                      
  # has_many :suggesters, :through => :questions
  #                                             
  # has_many :user_answers, :through => :questions
  # 
  # has_many :participations, :dependent => :destroy
  #                      
  # has_many :participants, :through => :participations,
  #                         :source => :user,
  #                         :order => 'LOWER(name) ASC'
  #                        
  # validates_presence_of :title,
  #                       :user_id,
  #                       :permalink
  # 
  # validates_uniqueness_of :title, :case_sensitive => false
  # 
  # before_validation :make_permalink
  # 
  # named_scope :recently_added, :limit => 10,
  #                              :order => 'created_at DESC'
  # 
  # named_scope :recently_updated, :conditions => 'questions_updated_at IS NOT NULL',
  #                                :limit => 10,
  #                                :order => 'questions_updated_at DESC'
  #                                
  # named_scope :recently_viewed, :conditions => 'last_viewed IS NOT NULL',
  #                               :limit => 15,
  #                               :order => 'last_viewed DESC'
  # 
  # def percentage_answered_correctly
  #   user_answers.correct.count / questions.approved.count * 100
  # rescue ZeroDivisionError
  #   0
  # end
  # 
  # def next_number
  #   questions.maximum(:number).try(:next) || 1
  # end
  # 
  # def to_param
  #   "#{id}-#{permalink}"
  # end
  # 
  # private
  # 
  # def make_permalink
  #   if attribute_present?(:title)
  #     self.permalink = title.parameterize
  #   end
  # end
end
