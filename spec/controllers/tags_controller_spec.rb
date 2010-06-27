require 'spec_helper'

describe TagsController do
  integrate_views
  fixtures :tags, :surveys
  
  describe '#show' do
    it {
      get :show, :survey_id => surveys(:ruby), :id => tags(:rails).id
      response.should be_success
      response.should render_template('show')
      assigns[:tag].should_not be_nil
      assigns[:questions].should_not be_nil
    }
  end
end