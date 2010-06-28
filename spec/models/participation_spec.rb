require 'spec_helper'

describe Participation do
  should_not_allow_mass_assignment_of :user_id,
                                      :survey_id,
                                      :correct_count,
                                      :incorrect_count
  
  should_belong_to :user, :survey
  
  should_validate_presence_of :user_id,
                              :survey_id
                              
  should_validate_uniqueness_of :survey_id, :scope => :user_id,
                                          :message => 'is already part of your participation list'
  
  describe 'custom validations' do    
    describe 'record' do
      it 'should not be valid if user is survey owner' do
        make_record
        error_str = 'You cannot participate in your own survey'
        @record.errors.full_messages.should include(error_str)
      end
      
      def make_record
        @record = Participation.new
        @record.user = users(:justin)
        @record.survey = surveys(:ruby)
        @record.save
        @record
      end
    end
  end
                                        
  describe '#after_destroy' do
    it 'should destroy user answers' do
      lambda {
        participations(:rails).destroy
      }.should change(UserAnswer, :count).by(-1)
    end
  end
end


# == Schema Information
#
# Table name: participations
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  survey_id       :integer
#  correct_count   :integer         default(0)
#  incorrect_count :integer         default(0)
#  created_at      :datetime
#  updated_at      :datetime
#

