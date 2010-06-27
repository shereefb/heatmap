require 'spec_helper'

describe UserAnswer do
  should_not_allow_mass_assignment_of :user_id,
                                      :question_id,
                                      :answer_id,
                                      :correct
  
  should_belong_to :user,
                   :question,
                   :answer
                   
  should_validate_presence_of :user_id,
                              :question_id,
                              :answer_id
                              
  should_validate_uniqueness_of :user_id, :scope => :question_id,
                                          :message => 'has already answered this question'
  
  should_have_scope :correct, :conditions => {:correct => true}
  
  describe 'custom validations' do    
    describe 'record' do
      it 'should be invalid if user is survey owner' do
        make_record
        error_str = 'You cannot answer a question in your own survey'
        @record.errors.full_messages.should include(error_str)
      end
      
      it 'should be invalid if user is not participating in survey' do
        UserAnswer.delete_all
        make_record
        error_str = 'You must be participating in this survey to answer questions'
        @record.errors.full_messages.should include(error_str)
      end
      
      it 'should be invalid if question is not approved' do
        questions(:ruby).update_attribute(:approved, false)
        make_record
        error_str = 'Question must be approved'
        @record.errors.full_messages.should include(error_str)
      end
      
      def make_record
        @record = UserAnswer.new
        @record.user = users(:justin)
        @record.question = questions(:ruby)
        @record.answer = answers(:ruby_correct)
        @record.save
        @record
      end
    end
  end
                                          
  describe '#correct?' do
    it { user_answers(:rails).should be_correct }
  end
  
  describe 'updating participant correct counts' do    
    before do
      UserAnswer.delete_all
      
      @user_answer = UserAnswer.new 
      @user_answer.user = users(:justin)
      @user_answer.question = questions(:rails)
      @user_answer.answer = answers(:rails_correct)
    end
    
    it 'should create a new record' do
      lambda {
        @user_answer.save!
      }.should change(UserAnswer, :count).by(1)
    end
    
    it 'should increment correct_count for participation' do
      mock.instance_of(Participation).increment!(:correct_count).once
      @user_answer.save!
    end
    
    it 'should increment incorrect_count for participation' do
      mock.instance_of(Participation).increment!(:incorrect_count).once
      @user_answer.answer = answers(:rails_incorrect)
      @user_answer.save!
    end
  end
end

# == Schema Information
#
# Table name: user_answers
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  question_id :integer
#  answer_id   :integer
#  correct     :boolean         default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

