# == Schema Information
#
# Table name: questions
#
#  id            :integer         not null, primary key
#  quiz_id       :integer
#  body          :text
#  answers_count :integer         default(0)
#  position      :integer
#  created_at    :datetime
#  updated_at    :datetime
#  number        :integer
#  suggester_id  :integer
#  approved      :boolean
#

class Question < ActiveRecord::Base
  
  attr_accessible :body,
                  :number,
                  :suggester_id
                    
  belongs_to :quiz, :counter_cache => true,
                    :touch => :questions_updated_at
  
  belongs_to :suggester, :class_name => 'User'
  
  has_many :answers, :order => 'answers.position ASC',
                     :dependent => :destroy
  
  has_many :user_answers, :dependent => :destroy
  
  validates_presence_of :quiz_id,
                        :body,
                        :number
                        
  validates_uniqueness_of :body,
                          :number, :scope => :quiz_id
  
  validates_numericality_of :number, :only_integer => true
  
  before_validation :set_number
  validate :suggester_is_not_quiz_owner
  
  named_scope :approved, :conditions => { :approved => true }
  named_scope :awaiting_approval, :conditions => { :approved => false }
                        
  acts_as_list :scope => :quiz_id
  
  acts_as_markdown :body
  
  
  def suggester?
    not suggester_id.blank?
  end
  
  def has_correct_answer?
    not correct_answer.nil?
  end
  
  def correct_answer
    answers.scoped_by_correct(true).first
  end
    
  def next
    self.class.first :conditions => ['quiz_id = ? AND id > ?', quiz_id, id],
                     :order => 'id ASC'
  end
  
  def prev
    self.class.first :conditions => ['quiz_id = ? AND id < ?', quiz_id, id],
                     :order => 'id DESC'
  end
  
  private
  
  def set_number
    if quiz and not attribute_present?(:number)
      self.number = quiz.next_number
    end
  end
  
  def suggester_is_not_quiz_owner
    if quiz and suggester and quiz.owner == suggester
      errors.add(:suggester_id, 'cannot be the quiz owner')
    end
  end
end
