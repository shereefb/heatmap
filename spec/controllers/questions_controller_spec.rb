require 'spec_helper'

describe QuestionsController do
  integrate_views
  fixtures :surveys, :questions
  
  before { login }
  
  describe '#suggest' do
    it 'should find the survey and render the suggest action' do
      get :suggest, :survey_id => surveys(:rails).id
      response.should be_success
      response.should render_template('suggest')
    end
  end
  
  describe '#new' do
    it 'should find the survey and render the new action' do
      get :new, :survey_id => surveys(:ruby).id
      response.should be_success
      response.should render_template('new')
    end
    
    it 'should not authorize the survey and redirect to root' do
      get :new, :survey_id => surveys(:rails).id
      response.should be_redirect
      response.should redirect_to(root_url)
    end
  end
  
  describe '#create' do
    before do
      @survey = surveys(:ruby)
    end
    
    it 'should create a new question and redirect' do
      lambda {
        post :create, :survey_id => @survey.id,
                      :question => {:body => 'blah'}
      }.should change(Question, :count).by(1)
      
      response.should be_redirect
      url = survey_question_url(@survey, assigns[:question])
      response.should redirect_to(url)
    end
    
    it 'should not create a new question and render the new action' do
      lambda {
        post :create, :survey_id => @survey.id,
                      :question => {:body => ''}
      }.should_not change(Question, :count)
      
      response.should be_success
      response.should render_template('new')
    end
    
    it 'should not authorize survey and redirect to root' do
      post :create, :survey_id => surveys(:rails).id,
                    :question => {:body => 'blah'}
                    
      response.should be_redirect
      response.should redirect_to(root_url)
    end
  end
  
  describe '#show' do
    describe 'with current_user as owner' do   
      it {
        get :show, :survey_id => surveys(:ruby).id,
                    :id => questions(:ruby).id
                    
        response.should be_success
        response.should render_template('show')
      }
    end
    
    describe 'with current_user as participant' do      
      it {
        get :show, :survey_id => surveys(:rails).id,
                   :id => questions(:rails).id
                   
        response.should be_success
        response.should render_template('show')
        
        assigns[:user_answer].should_not be_nil
        assigns[:total_answered].should_not be_nil
        assigns[:total_questions].should_not be_nil
        assigns[:participation].should_not be_nil
      }
    end
    
    describe 'with current_user as suggester' do
      before do
        @q = Question.new
        @q.survey = surveys(:rails)
        @q.suggester = users(:justin)
        @q.body = 'blah test'
        @q.save!
      end
      
      it {
        get :show, :survey_id => surveys(:rails).id,
                   :id => @q.id
                   
        response.should be_success
        response.should render_template('show')
        
        assigns[:user_answer].should be_nil
        assigns[:total_answered].should be_nil
        assigns[:total_questions].should be_nil
        assigns[:participation].should be_nil
        
        assigns[:suggested_questions].should include(@q)
      }
    end
  end
  
  describe '#edit' do    
    it 'should render the edit action if authorized' do
      get :edit, :survey_id => surveys(:ruby).id,
                 :id => questions(:ruby).id
                 
      response.should be_success
      response.should render_template('edit')
    end
    
    it 'should redirect if survey is unauthorized' do
      get :edit, :survey_id => surveys(:rails).id,
                 :id => questions(:rails).id
                 
      response.should be_redirect
      response.should redirect_to(root_url)
    end
  end
  
  describe '#update' do
    before do
      @survey = surveys(:ruby)
      @question = questions(:ruby)
    end
    
    it 'should update a question and redirect' do
      put :update, :survey_id => @survey.id,
                   :id => @question.id,
                   :question => {:body => 'test body'}
      
      @question.reload.body.to_s.should eql('test body')
      response.should be_redirect
      response.should redirect_to(survey_question_url(@survey, @question))
    end
    
    it 'should not update a question and render edit action' do
      put :update, :survey_id => @survey.id,
                   :id => @question.id,
                   :question => {:body => ''}
      
      @question.reload.body.to_s.should eql('This is the body.')
      response.should be_success
      response.should render_template('edit')
    end
  end
  
  describe '#approve' do    
    it 'should change the question to approved' do
      question = questions(:ruby)
      question.update_attribute(:approved, false)
      
      lambda {
        put :approve, :id => question.id
      }.should change { question.reload.approved }.from(false).to(true)
      
      response.should be_redirect
      
      url = survey_question_url(question.survey, question)
      response.should redirect_to(url)
    end
    
    it 'should deny access' do
      question = questions(:rails)
      question.update_attribute(:approved, false)

      lambda {
        put :approve, :id => question.id
      }.should_not change { question.reload.approved }

      response.should be_redirect
      response.should redirect_to(root_url)
    end
  end
end

describe QuestionsController, 'User not logged in' do
  integrate_views
  fixtures :surveys, :questions
  
  it 'should redirect to login for new action' do
    get :new
    response.should redirect_to(login_url)
  end
  
  it 'should render the show action successfully' do
    get :show, :survey_id => surveys(:rails).id,
               :id => questions(:rails).id
               
    response.should be_success
    response.should render_template('show')
  end
end
