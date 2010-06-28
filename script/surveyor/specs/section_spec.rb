require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'section'

describe SurveyParser::Section, "when first created" do

  before(:each) do
    @section = SurveyParser::Section.new(mock("SurveyParser::Survey", :id => 2, :parser => mock("SurveyParser::Parser", :new_section_id => 1)), ["Demographics"], {})
  end
  
  it "should generate a data export identifier" do
    @section.data_export_identifier.should == "demographics"
  end
  
  it "should find a question by reference" do
    @section.questions << mock("SurveyParser::Question", :reference_identifier => "1", :text => "foo")
    @section.questions << mock("SurveyParser::Question", :reference_identifier => "2", :text => "foo")
    @section.questions << mock("SurveyParser::Question", :reference_identifier => "3", :text => "foo")
    
    q = @section.find_question_by_reference("2")
    q.should_not be_nil
    q.reference_identifier.should == "2"
  end
end
