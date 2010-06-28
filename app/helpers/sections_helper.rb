module SectionsHelper
  def show_section_number(section)
    survey = @survey || section.survey
    link_to '#' + section.id.to_s, survey_section_path(survey, section)
  end

  def show_question_number(question)
    section = @section || question.section
    survey = @survey || section.survey
    link_to '#' + question.id.to_s, edit_survey_section_question_path(survey, section, question)
  end
end
