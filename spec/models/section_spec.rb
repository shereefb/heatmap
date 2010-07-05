require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Section, "when saving a section" do
  before(:each) do
    @valid_attributes={:title => "foo", :survey_id => 2, :display_order => 4}
    @section = Section.new(@valid_attributes)
  end

  it "should be invalid without title" do
    @section.title = nil
    @section.should have(1).error_on(:title)
  end
  
  it "should have a parent survey" do
    @section.survey_id = nil
    @section.should have(1).error_on(:survey)
  end
end

describe Section, "with questions" do
  before(:each) do
    @section = Factory(:section, :title => "Rhymes", :display_order => 4)
    @q1 = @section.questions.create(:text => "Peep", :display_order => 3)
    @q2 = @section.questions.create(:text => "Little", :display_order => 1)
    @q3 = @section.questions.create(:text => "Bo", :display_order => 2)
  end
  
  it "should return questions sorted in display order" do
    @section.questions.should have(3).questions
    @section.questions.should == [@q2,@q3,@q1]
  end
end

# == Schema Information
#
# Table name: sections
#
#  id                     :integer         not null, primary key
#  survey_id              :integer
#  title                  :string(255)
#  description            :text
#  reference_identifier   :string(255)
#  data_export_identifier :string(255)
#  common_namespace       :string(255)
#  common_identifier      :string(255)
#  display_order          :integer
#  custom_class           :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

