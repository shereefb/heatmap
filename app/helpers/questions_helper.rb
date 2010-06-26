# module QuestionsHelper
#   def correct_or_incorrect
#     return if @user_answer.new_record?
#     
#     str = if @user_answer.correct?
#       'correct'
#     else
#       'incorrect'
#     end
#     
#     content_tag :div, str.upcase, :id => 'mid_nav', :class => str
#   end
#   
#   def user_answer_li_class(answer)
#     return if @user_answer.new_record?
#     return unless @user_answer.answer == answer
#     answer == @question.correct_answer ? 'correct' : 'incorrect'
#   end
#   
#   def prev_question
#     str = '&larr; Prev Question'
#     if prev_question_record = @question.prev
#       link_to str, quiz_question_path(@quiz, prev_question_record)
#     else
#       str
#     end
#   end
#   
#   def next_question
#     str = 'Next Question &rarr;'
#     if next_question_record = @question.next
#       link_to str, quiz_question_path(@quiz, next_question_record)
#     else
#       str
#     end
#   end
#   
#   def total_answered
#     plural_str = @total_answered == 1 ? 'question' : 'questions'
#     num = number_with_delimiter(@total_answered)
#     content_tag(:strong, num) + " #{plural_str}"
#   end
#   
#   def all_questions_answered?
#     @total_answered == @total_questions
#   end
#   
#   def show_number(question)
#     quiz = @quiz || question.quiz
#     link_to '#' + question.number.to_s, quiz_question_path(quiz, question)
#   end
# end
