class Answer < ActiveRecord::Base

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

# == Schema Information
#
# Table name: answers
#
#  id                     :integer         not null, primary key
#  question_id            :integer
#  text                   :text
#  short_text             :text
#  help_text              :text
#  weight                 :integer
#  response_class         :string(255)
#  reference_identifier   :string(255)
#  data_export_identifier :string(255)
#  common_namespace       :string(255)
#  common_identifier      :string(255)
#  display_order          :integer
#  is_exclusive           :boolean
#  hide_label             :boolean
#  display_length         :integer
#  custom_class           :string(255)
#  custom_renderer        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

