class ValidationCondition < ActiveRecord::Base

  # Constants
  OPERATORS = %w(== != < > <= >= =~)

  # Associations
  belongs_to :validation
  
  # Scopes
  
  # Validations
  validates_numericality_of :validation_id #, :question_id, :answer_id
  validates_presence_of :operator, :rule_key
  validates_inclusion_of :operator, :in => OPERATORS
  validates_uniqueness_of :rule_key, :scope => :validation_id
  
  acts_as_response # includes "as" instance method
  
  # Class methods
  def self.operators
    OPERATORS
  end
  
  # Instance Methods
  def to_hash(response)
    {rule_key.to_sym => (response.nil? ? false : self.is_valid?(response))}
  end
  
  def is_valid?(response)
    klass = response.answer.response_class
    compare_to = Response.find_by_question_id_and_answer_id(self.question_id, self.answer_id) || self
    case self.operator
    when "==", "<", ">", "<=", ">="
      response.as(klass).send(self.operator, compare_to.as(klass))
    when "!="
      !(response.as(klass) == compare_to.as(klass))
    when "=~"
      return false if compare_to != self
      !(response.as(klass).to_s =~ Regexp.new(self.regexp || "")).nil?
    else
      false
    end
  end
end

# == Schema Information
#
# Table name: validation_conditions
#
#  id             :integer         not null, primary key
#  validation_id  :integer
#  rule_key       :string(255)
#  operator       :string(255)
#  question_id    :integer
#  answer_id      :integer
#  datetime_value :datetime
#  integer_value  :integer
#  float_value    :float
#  unit           :string(255)
#  text_value     :text
#  string_value   :string(255)
#  response_other :string(255)
#  regexp         :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

