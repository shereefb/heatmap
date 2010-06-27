require 'spec_helper'

describe Question do
  should_not_allow_mass_assignment_of :survey_id
  
  should_belong_to :survey,
                   :suggester
  
  should_have_many :answers,
                   :user_answers
  
  should_validate_presence_of :survey_id,
                              :body,
                              :number
                              
  should_validate_uniqueness_of :body,
                                :number, :scope => :survey_id
  
  should_validate_numericality_of :number, :only_integer => true
  
  should_have_scope :approved, :conditions => { :approved => true }
  should_have_scope :awaiting_approval, :conditions => { :approved => false }
  
  describe 'custom validations' do    
    it 'should set number if not set by user' do
      Question.delete_all
      
      q = Question.new
      q.survey = surveys(:ruby)
      q.body = 'blah'
      q.save!
      
      q.number.should eql(1)
    end
    
    it 'should not set number if set by user' do      
      q = questions(:rails)
      q.number = 55555
      q.save!
      
      q.number.should eql(55555)
    end
    
    it 'should not allow suggester to be survey owner' do
      q = questions(:rails)
      q.suggester = surveys(:rails).user
      q.save
      
      q.errors.on(:suggester_id).should eql('cannot be the survey owner')
    end
  end
  
  describe '#suggester?' do
    it { questions(:rails).should_not be_suggester }
    
    it {
      questions(:rails).update_attribute(:suggester_id, 55555)
      questions(:rails).should be_suggester
    }
  end
  
  describe '#has_correct_answer?' do
    it { questions(:rails).has_correct_answer?.should be_true }
    
    describe 'with all answers deleted' do
      before { Answer.delete_all }
      it { questions(:rails).has_correct_answer?.should be_false }
    end
  end
  
  describe '#correct_answer' do
    it { questions(:rails).answers.first == questions(:rails).correct_answer }
  end
  
  describe '#next and #prev' do    
    before do
      3.times do |i|
        
        q      = Question.new
        q.survey = surveys(:rails)
        q.body = 'blah' + i.to_s
        q.save!
      end
      
      @question = Question.all.at(3)
    end
    
    it { @question.next.id.should == @question.id + 1 }
    it { @question.prev.id.should == @question.id - 1 }
  end
end

# == Schema Information
#
# Table name: questions
#
#  id                     :integer         not null, primary key
#  survey_section_id      :integer
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

