class Question < ActiveRecord::Base

  # Extending surveyor
  include "#{self.name}Extensions".constantize if Surveyor::Config['extend'].include?(self.name.underscore)
    
  # Associations
  belongs_to :survey_section
  belongs_to :question_group
  has_many :answers, :order => "display_order ASC" # it might not always have answers
  has_one :dependency

  # Scopes
  default_scope :order => "display_order ASC"
  
  # Validations
  validates_presence_of :text, :survey_section_id, :display_order
  validates_inclusion_of :is_mandatory, :in => [true, false]
  
  # Instance Methods
  def initialize(*args)
    super(*args)
    default_args
  end
  
  def default_args
    self.is_mandatory ||= true
    self.display_type ||= "default"
    self.pick ||= "none"
  end
  
  def mandatory?
    self.is_mandatory == true
  end
  
  def dependent?
    self.dependency != nil
  end
  def triggered?(response_set)
    dependent? ? self.dependency.is_met?(response_set) : true
  end
  def css_class(response_set)
    [(dependent? ? "dependent" : nil), (triggered?(response_set) ? nil : "hidden"), custom_class].compact.join(" ")
  end
  
  def part_of_group?
    !self.question_group.nil?
  end

  def renderer(g = question_group)
    r = [g ? g.renderer.to_s : nil, display_type].compact.join("_")
    r.blank? ? :default : r.to_sym
  end
  
end

# # == Schema Information
# #
# # Table name: questions
# #
# #  id            :integer         not null, primary key
# #  quiz_id       :integer
# #  body          :text
# #  answers_count :integer         default(0)
# #  position      :integer
# #  created_at    :datetime
# #  updated_at    :datetime
# #  number        :integer
# #  suggester_id  :integer
# #  approved      :boolean
# #
# 
# class Question < ActiveRecord::Base
#   
#   attr_accessible :body,
#                   :number,
#                   :suggester_id
#                     
#   belongs_to :quiz, :counter_cache => true,
#                     :touch => :questions_updated_at
#   
#   belongs_to :suggester, :class_name => 'User'
#   
#   has_many :answers, :order => 'answers.position ASC',
#                      :dependent => :destroy
#   
#   has_many :user_answers, :dependent => :destroy
#   
#   validates_presence_of :quiz_id,
#                         :body,
#                         :number
#                         
#   validates_uniqueness_of :body,
#                           :number, :scope => :quiz_id
#   
#   validates_numericality_of :number, :only_integer => true
#   
#   before_validation :set_number
#   validate :suggester_is_not_quiz_owner
#   
#   named_scope :approved, :conditions => { :approved => true }
#   named_scope :awaiting_approval, :conditions => { :approved => false }
#                         
#   acts_as_list :scope => :quiz_id
#   
#   acts_as_markdown :body
#   
#   
#   def suggester?
#     not suggester_id.blank?
#   end
#   
#   def has_correct_answer?
#     not correct_answer.nil?
#   end
#   
#   def correct_answer
#     answers.scoped_by_correct(true).first
#   end
#     
#   def next
#     self.class.first :conditions => ['quiz_id = ? AND id > ?', quiz_id, id],
#                      :order => 'id ASC'
#   end
#   
#   def prev
#     self.class.first :conditions => ['quiz_id = ? AND id < ?', quiz_id, id],
#                      :order => 'id DESC'
#   end
#   
#   private
#   
#   def set_number
#     if quiz and not attribute_present?(:number)
#       self.number = quiz.next_number
#     end
#   end
#   
#   def suggester_is_not_quiz_owner
#     if quiz and suggester and quiz.owner == suggester
#       errors.add(:suggester_id, 'cannot be the quiz owner')
#     end
#   end
# end
