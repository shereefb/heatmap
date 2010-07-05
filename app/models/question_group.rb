class QuestionGroup < ActiveRecord::Base

  
  has_many :questions
  has_one :dependency
  
  # Instance Methods
  def initialize(*args)
    super(*args)
    default_args
  end
  
  def default_args
    self.display_type ||= "inline"
    self.is_mandatory ||= false
    self.text ||= self.bdesc
  end

  def renderer
    display_type.blank? ? :default : display_type.to_sym
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
  
  def after_create
    generate_questions
  end
  
  def before_update
    return if self.id.nil?
    self.text = self.bdesc
    if self.adesc_changed? || self.qdesc_changed?  
      self.questions.each do |q| q.destroy end
      generate_questions
    end
  end
  
  def generate_questions
    self.qdesc.split("\n").each do |question_text|
      Question.create :qdesc => question_text, :adesc => self.adesc, :pick => 'one', :variation => 'pickoneradio', :is_mandatory => self.is_mandatory, :section_id => self.section_id, :question_group_id => self.id
    end
  end
  
end


# == Schema Information
#
# Table name: question_groups
#
#  id                     :integer         not null, primary key
#  text                   :text
#  help_text              :text
#  reference_identifier   :string(255)
#  data_export_identifier :string(255)
#  common_namespace       :string(255)
#  common_identifier      :string(255)
#  display_type           :string(255)
#  custom_class           :string(255)
#  custom_renderer        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  qdesc                  :text
#  adesc                  :text
#  section_id             :integer
#

