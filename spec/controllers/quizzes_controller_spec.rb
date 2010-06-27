require 'spec_helper'

describe SurveysController do
  integrate_views
  fixtures :surveys
  
  before { login }
  
  describe '#index' do
    it {
      get :index
      response.should be_success
      response.should render_template('index')
      assigns[:surveys].should_not be_nil
    }
  end
  
  describe '#new' do
    it {
      get :new
      response.should be_success
      response.should render_template('new')
    }
  end
  
  describe '#create' do
    it 'should create a survey successfully and redirect' do
      lambda {
        post :create, :survey => {:title => 'blah'}
      }.should change(Survey, :count).by(1)
      
      response.should be_redirect
      response.should redirect_to(survey_url(assigns[:survey]))
    end
    
    it 'should not create a survey and render the new action' do
      lambda {
        post :create, :survey => {:title => ''}
      }.should_not change(Survey, :count)
      
      response.should be_success
      response.should render_template('new')
    end
  end
  
  describe '#edit' do
    it 'should authorize the survey' do
      get :edit, :id => surveys(:ruby).id
      response.should be_success
      response.should render_template('edit')
    end
    
    it 'should not authorize the survey and redirect to root' do
      get :edit, :id => surveys(:rails).id
      response.should be_redirect
      response.should redirect_to(root_url)
    end
  end
  
  describe '#update' do 
    before { @survey = surveys(:ruby) }
    
    it 'should update a survey successfully' do
      put :update, :id => @survey.id, :survey => {:title => 'new title'}
      
      assigns[:survey].title.should eql('new title')
      
      response.should be_redirect
      response.should redirect_to(survey_url(assigns[:survey]))
    end
    
    it 'should not update a survey and render the edit action' do
      put :update, :id => @survey.id, :survey => {:title => ''}
      response.should be_success
      response.should render_template('edit')
    end
    
    it 'should not authorize the survey and redirect to root' do
      put :update, :id => surveys(:rails).id, :survey => {:title => 'new title'}
      response.should be_redirect
      response.should redirect_to(root_url)
    end
  end
  
  describe '#show' do
    it 'should render successfully and touch last_viewed' do
      lambda {
        get :show, :id => surveys(:rails).id
      }.should change { surveys(:rails).reload.last_viewed }
      
      response.should be_success
      response.should render_template('show')
    end
    
    it 'should render successfully and not touch last_viewed' do
      lambda {
        get :show, :id => surveys(:ruby).id
      }.should_not change { surveys(:ruby).reload.last_viewed }
      
      response.should be_success
      response.should render_template('show')
    end
  end
  
  describe '#participate' do
    fixtures :participations
       
    it 'should not be succcessful if survey owner is current_user' do
      lambda {
        post :participate, :id => surveys(:ruby).id
      }.should_not change(Participation, :count)
      
      flash[:failure].should eql('You cannot participate in your own survey')
      response.should be_redirect
      response.should redirect_to(survey_url(assigns[:survey]))
    end
    
    it 'should not be successful if current_user is already participating in the survey' do
      lambda {
        post :participate, :id => surveys(:rails).id
      }.should_not change(Participation, :count)

      flash[:failure].should eql('Survey is already part of your participation list')
      response.should be_redirect
      response.should redirect_to(survey_url(assigns[:survey]))
    end
    
    it 'should create a new participation record and redirect to survey' do
      participations(:rails).destroy
      survey = surveys(:rails)
      
      lambda {
        post :participate, :id => survey.id
      }.should change(Participation, :count).by(1)
      
      flash[:success].should eql('You are now participating in this survey')
      response.should be_redirect
      response.should redirect_to(survey_url(survey))
    end
  end
end

describe SurveysController, 'User not logged in' do
  integrate_views
  fixtures :surveys
  
  it 'should render the index action' do
    get :index
    response.should be_success
    response.should render_template('index')
  end
  
  it 'should render the show action' do
    get :show, :id => surveys(:rails).id
    response.should be_success
    response.should render_template('show')
  end
end
