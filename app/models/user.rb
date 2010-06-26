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

class User < ActiveRecord::Base
  
  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
    config.perishable_token_valid_for = 1.hour
  end
    
  has_many :quizzes, :order => 'LOWER(title) ASC',
                     :dependent => :destroy
  
  has_many :questions, :through => :quizzes
  
  has_many :suggested_questions, :class_name => 'Question',
                                 :foreign_key => 'suggester_id',
                                 :dependent => :nullify
                                 
  has_many :suggested_answers, :through => :suggested_questions,
                               :source => :answers
    
  has_many :participations, :dependent => :destroy
  
  has_many :participating_quizzes, :through => :participations,
                                   :source => :quiz
  
  has_many :answers, :class_name => 'UserAnswer',
                     :dependent => :destroy
  
  validates_presence_of :name,
                        :username
  
  validates_uniqueness_of :name, 
                          :username, :case_sensitive => false
  
  validates_format_of :username, :with => /\A\w+\z/i,
                                 :message => 'only letters, numbers, and underscores please'
                                 
  validates_exclusion_of :username, :in => BLACKLIST_USERNAMES,
                                    :message => 'is not allowed'
  
  def self.find_by_username_or_email(login)
    find_by_username(login) || find_by_email(login)
  end
  
  def participating_quizzes_for_dashboard
    quizzes_columns = 'quizzes.permalink, quizzes.id, quizzes.title, ' +
                      'quizzes.questions_count, quizzes.participations_count'
    
    select_sql = quizzes_columns + ', ' +
                 'participations.correct_count AS correct_count, ' +
                 'participations.incorrect_count AS incorrect_count, ' +
                 'COUNT(user_answers.question_id) AS user_answer_count'
    
    joins_sql = 'LEFT OUTER JOIN questions ON (quizzes.id = questions.quiz_id) ' +
                'LEFT OUTER JOIN user_answers ON (user_answers.question_id = questions.id)'
                
    group_sql = quizzes_columns + ', ' + 
                'participations.correct_count, participations.incorrect_count'
    
    participating_quizzes.all :select => select_sql,
                              :joins => joins_sql,
                              :group => group_sql,
                              :order => 'LOWER(quizzes.title) ASC'
  end
  
  def suggested_questions_for_quiz(quiz)
    suggested_questions.all :conditions => { :quiz_id => quiz }
  end
  
  def participate!(quiz)
    participation = participations.build
    participation.quiz = quiz
    participation.save!
  end
  
  def participating?(quiz)
    participations.exists?(:quiz_id => quiz)
  end
  
  def answer_question!(question, params)
    answer_id = params[:user_answer][:answer_id]
    answer = question.answers.find(answer_id)
    
    user_answer = answers.build
    user_answer.question = question
    user_answer.answer = answer
    user_answer.save!
  end
  
  def all_answered?(quiz)
    total_answered(quiz) == quiz.questions.count
  end
  
  def total_answered(quiz)
    answers.count(:conditions => { :question_id => quiz.question_ids })
  end
  
  def can_edit_answer?(answer)
    question_ids.include?(answer.question_id) ||
    suggested_answers.include?(answer)
  end
  
  def can_edit_question?(question)
    question.suggester == self || questions.include?(question)
  end
  
  def can_edit_quiz?(quiz)
    quiz.user_id == id || quiz.suggesters.include?(self)
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Emailer.deliver_password_reset_instructions(self)
  end
    
  def find_participation(quiz)
    participations.find_by_quiz_id(quiz)
  end
end
