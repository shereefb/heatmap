require 'spec_helper'

describe ParticipationsController do
  integrate_views
  fixtures :participations
  
  before { login }
  
  describe '#destroy' do
    it 'should delete a record and redirect to survey' do
      participation = participations(:rails)
      
      lambda {
        delete :destroy, :id => participation.id
      }.should change(Participation, :count).by(-1)
      
      flash[:success].should eql('You are no longer participating in this survey')
      response.should be_redirect
      response.should redirect_to(survey_url(participation.survey))
    end
    
    it 'should rescue RecordNotFound and redirect to survey' do
      lambda {
        delete :destroy, :id => 12345
      }.should_not change(Participation, :count)
      
      flash[:failure].should eql('Participation not found')
      response.should be_redirect
      response.should redirect_to(root_url)
    end
  end
end

describe ParticipationsController, 'User not logged in' do
  it 'should redirect to root' do
    delete :destroy, :id => 12345
    response.should be_redirect
    response.should redirect_to(login_url)
  end
end
