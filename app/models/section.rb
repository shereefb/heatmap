class Section < ActiveRecord::Base
  # Associations
  has_many :questions, :order => "display_order ASC"
  belongs_to :survey
  
  # Scopes
  default_scope :order => "display_order ASC"
  named_scope :with_includes, { :include => {:questions => [:answers, :question_group, {:dependency => :dependency_conditions}]}}
  
  # Validations
  validates_presence_of :title, :survey #, :display_order
  
end


# == Schema Information
#
# Table name: sections
#
#  id                     :integer         not null, primary key
#  survey_id              :integer
#  title                  :string(255)
#  description            :text
#  reference_identifier   :string(255)
#  data_export_identifier :string(255)
#  common_namespace       :string(255)
#  common_identifier      :string(255)
#  display_order          :integer
#  custom_class           :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

