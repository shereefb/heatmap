require 'spec_helper'

describe AnswersController, 'User logged in' do
  integrate_views
  fixtures :surveys, :questions, :answers
  
  before do
    login
    @answer = answers(:ruby_correct)
  end
  
  it 'should create an answer record' do
    lambda {
      post :create, answer_params
    }.should change(Answer, :count).by(1)
  end
  
  it 'should redirect to question' do
    post :create, answer_params
    response.should be_redirect
    path = survey_question_path(surveys(:ruby), questions(:ruby))
    response.should redirect_to(path)
  end
  
  it 'should render the edit partial' do
    get :edit, :id => @answer.id, :format => 'js'
    response.should respond_with(:success, :content_type => :js)
  end
  
  it 'should update successfully' do
    put :update, :id => @answer.id, :format => 'js', :answer => {}
    response.should respond_with(:success, :content_type => :js)
  end
  
  it 'should not update and render text' do
    put :update, :id => @answer.id, :format => 'js', :answer => {:body => ''}
    response.should respond_with(:unprocessable_entity, :content_type => :js)
  end
  
  it 'should render the show action' do
    get :show, :id => @answer.id, :format => 'js'
    response.should respond_with(:success, :content_type => :js)
  end
    
  it 'should destroy an answer' do
    delete :destroy, :id => @answer.id, :format => 'js'
    response.should respond_with(:success, :content_type => :js)
  end
  
  def answer_params
    { :id => surveys(:ruby),
      :question_id => questions(:ruby),
      :answer => {:body => 'blah'}
    }
  end
end

describe AnswersController, 'User not logged in' do
  integrate_views
  fixtures :answers
  
  it 'should redirect to home' do
    get :edit, :id => answers(:rails_correct).id
    response.should be_redirect
    response.should redirect_to(login_url)
  end
end