class Question < ActiveRecord::Base

  # Associations
  belongs_to :section
  belongs_to :question_group
  has_many :answers, :order => "display_order ASC" # it might not always have answers
  has_one :dependency

  # Scopes
  default_scope :order => "display_order ASC"
  
  # Validations
  validates_presence_of :text, :section_id #, :display_order
  validates_inclusion_of :is_mandatory, :in => [true, false]
  
  # Instance Methods
  def initialize(*args)
    logger.info("creating question with #{args.inspect}")
    super(*args)
    default_args
  end
  
  def default_args
    self.is_mandatory ||= false
    self.display_type ||= "default"
    self.pick ||= "none"
    self.text ||= self.qdesc
    self.short_text ||= self.text
    self.data_export_identifier ||= Surveyor.to_normalized_string(self.text) unless self.text.nil?
    self.display_order ||= section.questions.size + 1
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
  
  def self.create_with_default_values(variation,params)
    case variation
      when 'pickoneradio':
        qdesc = "What is your favorite color?"
        adesc = "Red\nBlue\nGreen\nYellow"
        new_params = {:pick => 'one'}
      when 'pickonedropdown':
        qdesc = "What is your favorite color?"
        adesc = "Red\nBlue\nGreen\nYellow"
        new_params = {:pick => 'one', :display_type => 'dropdown'}
      when 'pickany':
        qdesc = "Pick as many flowers as you want?"
        adesc = "Rose\nTulip\nDaisy\nSun Flower"
        new_params = {:pick => 'any'}
      when 'string':
        qdesc = "What is your first name?"
        adesc = "String"
        new_params = {:pick => 'none'}
      when 'stringmultiple':
        qdesc = "What is your name?"
        adesc = "First\nMiddle\nLast"
        new_params = {:pick => 'none'}
      when 'label':
        qdesc = "This is just a label\nNothing needed from you."
        # adesc = "First\nMiddle\nLast"
        new_params = {:pick => 'none', :display_type => 'label'}
      when 'textarea':
        qdesc = "Write an essay about essays"
        adesc = "Text"
        new_params = {:pick => 'none'}
      # when 'number':
      # when 'float':
      # when 'datetime':
      # when 'date':
      # when 'time':
      when 'slider':
        qdesc = "What is your pain threshold?"
        adesc = "1 (low)\n2\n3\n4\n5 (high)"
        new_params = {:pick => 'one', :display_type => 'slider'}
      # when 'grid':
      # when 'rank':
      # when 'repeater':
    end
    @question = Question.new({:qdesc => qdesc, :adesc => adesc}.merge(params).merge(new_params).merge({:variation => variation}))
    # @question = Question.new({:text => "What's your favorite color?", :pick => :one}.merge(params))
    @question.save
    
    @question
  end
  
  def is_complex?
    case self.variation
      when 'pickoneradio':
        return false;
      when 'pickonedropdown':
        return false;
      when 'pickany':
        return false;
      when 'string':
        return false;
      when 'stringmultiple':
        return false;
      when 'label':
        return false;
      when 'textarea':
        return false;
      when 'number':
        return false;
      when 'float':
        return false;
      when 'datetime':
        return false;
      when 'date':
        return false;
      when 'time':
        return false;
      when 'slider':
        return false;
      when 'grid':
        return true;
      when 'rank':
        return true;
      when 'repeater':
        return true;
    end
    return false;
  end
  
  
  def has_predefined_answers?
    case self.variation
      when 'pickoneradio':
        return true;
      when 'pickonedropdown':
        return true;
      when 'pickany':
        return true;
      when 'string':
        return false;
      when 'stringmultiple':
        return true;
      when 'label':
        return false;
      when 'textarea':
        return false;
      when 'number':
        return false;
      when 'float':
        return false;
      when 'datetime':
        return false;
      when 'date':
        return false;
      when 'time':
        return false;
      when 'slider':
        return true;
      when 'grid':
        return true;
      when 'rank':
        return true;
      when 'repeater':
        return true;
    end
    return false;
  end
  
  
  def find_answer_by_reference(ref_id)
    self.answers.detect{|a| a.reference_identifier == ref_id}
  end
  
  def before_update
    return if self.id.nil?
    self.text = self.qdesc
    self.short_text = self.qdesc
    generate_answers(self.adesc, :true) if self.adesc_changed?
  end
  
  def after_create
    generate_answers(self.adesc, :false)
  end
  
  
  def generate_answers(adesc, delete_old_answers_first)
    self.answers.each do |a| a.destroy end if delete_old_answers_first
      
    return if adesc.nil? || self.id.nil?
    
    adesc.split("\n").each do |answer_text|
      case self.variation
        when 'pickoneradio':
          Answer.create :question_id => self.id, :text => answer_text
        when 'pickonedropdown':
          Answer.create :question_id => self.id, :text => answer_text
        when 'pickany':
          Answer.create :question_id => self.id, :text => answer_text
        when 'string':
          Answer.create :question_id => self.id, :text => answer_text, :hide_label => true, :response_class => 'string'
        when 'stringmultiple':
          Answer.create :question_id => self.id, :text => answer_text, :response_class => 'string'
        when 'label':
        when 'textarea':
          Answer.create :question_id => self.id, :text => answer_text, :response_class => 'text', :hide_label => true
        when 'number':
          Answer.create :question_id => self.id, :text => answer_text, :hide_label => true
        when 'float':
          Answer.create :question_id => self.id, :text => answer_text, :hide_label => true
        when 'datetime':
          Answer.create :question_id => self.id, :text => answer_text, :response_class => 'datetime', :hide_label => true
        when 'date':
          Answer.create :question_id => self.id, :text => answer_text, :response_class => 'date', :hide_label => true
        when 'time':
          Answer.create :question_id => self.id, :text => answer_text, :response_class => 'time', :hide_label => true
        when 'slider':
          Answer.create :question_id => self.id, :text => answer_text, :hide_label => true
        when 'grid':
        when 'rank':
        when 'repeater':
      end
    end
  end
end

# # == Schema Information
# #
# # Table name: questions
# #
# #  id            :integer         not null, primary key
# #  survey_id       :integer
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
#   belongs_to :survey, :counter_cache => true,
#                     :touch => :questions_updated_at
#   
#   belongs_to :suggester, :class_name => 'User'
#   
#   has_many :answers, :order => 'answers.position ASC',
#                      :dependent => :destroy
#   
#   has_many :user_answers, :dependent => :destroy
#   
#   validates_presence_of :survey_id,
#                         :body,
#                         :number
#                         
#   validates_uniqueness_of :body,
#                           :number, :scope => :survey_id
#   
#   validates_numericality_of :number, :only_integer => true
#   
#   before_validation :set_number
#   validate :suggester_is_not_survey_owner
#   
#   named_scope :approved, :conditions => { :approved => true }
#   named_scope :awaiting_approval, :conditions => { :approved => false }
#                         
#   acts_as_list :scope => :survey_id
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
#     self.class.first :conditions => ['survey_id = ? AND id > ?', survey_id, id],
#                      :order => 'id ASC'
#   end
#   
#   def prev
#     self.class.first :conditions => ['survey_id = ? AND id < ?', survey_id, id],
#                      :order => 'id DESC'
#   end
#   
#   private
#   
#   def set_number
#     if survey and not attribute_present?(:number)
#       self.number = survey.next_number
#     end
#   end
#   
#   def suggester_is_not_survey_owner
#     if survey and suggester and survey.owner == suggester
#       errors.add(:suggester_id, 'cannot be the survey owner')
#     end
#   end
# end


# == Schema Information
#
# Table name: questions
#
#  id                     :integer         not null, primary key
#  section_id             :integer
#  question_group_id      :integer
#  text                   :text
#  short_text             :text
#  help_text              :text
#  pick                   :string(255)
#  reference_identifier   :string(255)
#  data_export_identifier :string(255)
#  common_namespace       :string(255)
#  common_identifier      :string(255)
#  display_order          :integer
#  display_type           :string(255)
#  is_mandatory           :boolean
#  display_width          :integer
#  custom_class           :string(255)
#  custom_renderer        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  correct_answer_id      :integer
#

