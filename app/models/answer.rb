class Answer < ActiveRecord::Base

  # Extending surveyor
  include "#{self.name}Extensions".constantize if Surveyor::Config['extend'].include?(self.name.underscore)
  
  # Associations
  belongs_to :question
  has_many :responses

  # Scopes
  default_scope :order => "display_order ASC"
  
  # Validations
  validates_presence_of :text
  validates_numericality_of :question_id, :allow_nil => false, :only_integer => true
  
  # Methods
  def renderer(q = question)  
    r = [q.pick.to_s, self.response_class].compact.map(&:downcase).join("_")
    r.blank? ? :default : r.to_sym
  end
  
end


# # == Schema Information
# #
# # Table name: answers
# #
# #  id          :integer         not null, primary key
# #  question_id :integer
# #  body        :text
# #  correct     :boolean
# #  position    :integer
# #  created_at  :datetime
# #  updated_at  :datetime
# #
# 
# class Answer < ActiveRecord::Base
#   
#   attr_accessible :body,
#                   :correct
#                   
#   belongs_to :question, :counter_cache => true
#   
#   has_many :user_answers, :dependent => :destroy
#   
#   validates_presence_of :question_id,
#                         :body
#                         
#   validates_uniqueness_of :body, :scope => :question_id
#     
#   acts_as_list :scope => :question_id
#   
#   acts_as_markdown :body
# end
