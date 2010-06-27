# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  email               :string(255)     not null
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer         default(0), not null
#  failed_login_count  :integer         default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  username            :string(255)
#

require 'spec_helper'

describe User do
  should_have_many :surveys,
                   :questions,
                   :suggested_questions,
                   :suggested_answers,
                   :participations,
                   :participating_surveys,
                   :answers
  
  should_validate_presence_of :name,
                              :username
  
  should_validate_uniqueness_of :name,
                                :username
                                
  should_allow_values_for :username,
                          'blah', 'test_user', '123_56',
                          :message => 'only letters, numbers, and underscores please'
                          
  should_not_allow_values_for :username,
                              'blah.', 'test_user,', '123_56+',
                              :message => 'only letters, numbers, and underscores please'
                              
  should_validate_exclusion_of :username, :in => BLACKLIST_USERNAMES,
                                          :message => 'is not allowed'                     
  
  before { @user = users(:justin) }
  
  describe '#find_by_username_or_email' do
    it { User.find_by_username_or_email(@user.username).should eql(@user) }
    it { User.find_by_username_or_email(@user.email).should eql(@user) }
    it { User.find_by_username_or_email('blah').should be_nil }
  end
  
  describe '#participating_surveys_for_dashboard' do
    before do
      @records = @user.participating_surveys_for_dashboard
    end
    
    it { @records.should have(1).item }
    it { @records.first.user_answer_count.to_i.should eql(1) }
    it { @records.first.id.should eql(surveys(:rails).id) }
    it { @records.first.title.to_s.should eql(surveys(:rails).title.to_s) }
    it { @records.first.correct_count.to_i.should eql(1) }
    it { @records.first.incorrect_count.to_i.should eql(0) }
  end
  
  describe '#suggested_questions_for_survey' do
    before do
      @survey = surveys(:rails)
      @user = @user
      
      @q = Question.new
      @q.survey = @survey
      @q.suggester = @user
      @q.body = 'blah test'
      @q.save!
    end
    
    it 'should include the newly created question' do
      @user.suggested_questions_for_survey(@survey).should include(@q)
    end
  end
  
  describe '#participate!' do
    before do
      Participation.delete_all
      @user = @user
    end
    
    it 'should create a participation record' do
      lambda {
        @user.participate!(surveys(:rails))
      }.should change(Participation, :count).by(1)
    end
    
    it 'should not create a participation record if user is survey owner' do
      lambda {
        @user.participate!(surveys(:ruby))
      }.should raise_exception(ActiveRecord::RecordInvalid)
    end
  end
  
  describe '#participating?' do
    before { @user = @user }
    
    it { @user.participating?(surveys(:rails)).should be_true }
    it { @user.participating?(surveys(:ruby)).should be_false }
  end
  
  describe '#answer_question!' do    
    before do
      UserAnswer.delete_all
      @user = @user
      @question = questions(:rails)
      @answer = answers(:rails_correct)
      @params = { :user_answer => { :answer_id => @answer.id }}
    end
    
    it 'should create a UserAnswer record' do
      lambda { create_user_answer }.should change(UserAnswer, :count).by(1)
    end
    
    describe 'with created UserAnswer record' do
      before do
        create_user_answer
        @user_answer = UserAnswer.first
      end
      
      it { @user_answer.question.should eql(@question) }
      it { @user_answer.answer.should eql(@answer) }
      
      it 'should raise exception if attempt to create again' do
        lambda {
          create_user_answer
        }.should raise_exception(ActiveRecord::RecordInvalid)
      end
    end
    
    def create_user_answer
      @user.answer_question!(@question, @params)
    end
  end
  
  describe '#all_answered?' do
    before do
      @user = @user
      @survey = surveys(:rails)
    end
    
    it { @user.all_answered?(@survey).should be_true }
    
    describe 'with second question created' do
      before do
        @survey.questions.create :body => 'testing'
      end
      
      it { @user.all_answered?(@survey).should be_false }
    end
  end
  
  describe '#total_answered' do
    it { @user.total_answered(surveys(:rails)).should eql(1) }
  end
  
  describe '#can_edit_answer?' do        
    it "should be true if user owns the answer's survey" do
      answer = answers(:ruby_correct)
      @user.can_edit_answer?(answer).should be_true
    end
    
    it "should be false if user does not own the answer's survey" do
      answer = answers(:rails_correct)
      @user.can_edit_answer?(answer).should be_false
    end
    
    describe 'with question_ids empty' do
      before do
        mock(@user).question_ids { [] }
      end
      
      it 'should return false if zero suggested_answers' do
        @user.can_edit_answer?(answers(:rails_correct)).should be_false
      end
      
      describe 'with suggested answers to include given answer' do
        fixtures :questions
        
        before do
          q = questions(:rails)
          q.suggester = @user
          q.save!
        end
        
        it { @user.can_edit_answer?(answers(:rails_correct)).should be_true }
      end
    end
  end
  
  describe '#can_edit_question?' do    
    describe 'with suggester as nil' do
      before do
        mock.instance_of(Question).suggester { nil }
      end
      
      it "should be true if user owns the question's survey" do
        question = questions(:ruby)
        @user.can_edit_question?(question).should be_true
      end
    
      it "should be false if user does not own the question's survey" do
        question = questions(:rails)
        @user.can_edit_question?(question).should be_false
      end
    end
    
    describe 'with suggester set to user' do
      before do
        mock.instance_of(Question).suggester { @user }
      end
      
      it { @user.can_edit_question?(questions(:ruby)).should be_true }
    end
  end
  
  describe '#can_edit_survey?' do
    before { @survey = surveys(:ruby) }
    
    it { @user.can_edit_survey?(@survey).should be_true }
    
    describe 'with survey suggesters set to empty array' do
      before do
        mock(@survey).user_id { nil }
        mock(@survey).suggesters { [] }
      end
      
      it { @user.can_edit_survey?(@survey).should be_false }
    end
    
    describe 'with survey suggesters set to array with user' do
      before do
        mock(@survey).user_id { nil }
        mock(@survey).suggesters { [@user] }
      end
      
      it { @user.can_edit_survey?(@survey).should be_true }
    end
  end
  
  describe '#deliver_password_reset_instructions!' do
    it 'should send an email to the user' do
      user = @user
      mock(Emailer).deliver_password_reset_instructions(user).once
      user.deliver_password_reset_instructions!
    end
  end
  
  describe '#find_participation' do    
    it 'should find the correct participation record' do
      participation = participations(:rails)
      survey = surveys(:rails)
      @user.find_participation(survey).should eql(participation)
    end
  end
end
