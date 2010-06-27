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
    
  has_many :surveys, :order => 'LOWER(title) ASC',
                     :dependent => :destroy
  
  has_many :questions, :through => :surveys
  
  has_many :suggested_questions, :class_name => 'Question',
                                 :foreign_key => 'suggester_id',
                                 :dependent => :nullify
                                 
  has_many :suggested_answers, :through => :suggested_questions,
                               :source => :answers
    
  has_many :participations, :dependent => :destroy
  
  has_many :participating_surveys, :through => :participations,
                                   :source => :survey
  
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
  
  def participating_surveys_for_dashboard
    surveys_columns = 'surveys.permalink, surveys.id, surveys.title, ' +
                      'surveys.questions_count, surveys.participations_count'
    
    select_sql = surveys_columns + ', ' +
                 'participations.correct_count AS correct_count, ' +
                 'participations.incorrect_count AS incorrect_count, ' +
                 'COUNT(user_answers.question_id) AS user_answer_count'
    
    joins_sql = 'LEFT OUTER JOIN questions ON (surveys.id = questions.survey_id) ' +
                'LEFT OUTER JOIN user_answers ON (user_answers.question_id = questions.id)'
                
    group_sql = surveys_columns + ', ' + 
                'participations.correct_count, participations.incorrect_count'
    
    participating_surveys.all :select => select_sql,
                              :joins => joins_sql,
                              :group => group_sql,
                              :order => 'LOWER(surveys.title) ASC'
  end
  
  def suggested_questions_for_survey(survey)
    suggested_questions.all :conditions => { :survey_id => survey }
  end
  
  def participate!(survey)
    participation = participations.build
    participation.survey = survey
    participation.save!
  end
  
  def participating?(survey)
    participations.exists?(:survey_id => survey)
  end
  
  def answer_question!(question, params)
    answer_id = params[:user_answer][:answer_id]
    answer = question.answers.find(answer_id)
    
    user_answer = answers.build
    user_answer.question = question
    user_answer.answer = answer
    user_answer.save!
  end
  
  def all_answered?(survey)
    total_answered(survey) == survey.questions.count
  end
  
  def total_answered(survey)
    answers.count(:conditions => { :question_id => survey.question_ids })
  end
  
  def can_edit_answer?(answer)
    question_ids.include?(answer.question_id) ||
    suggested_answers.include?(answer)
  end
  
  def can_edit_question?(question)
    question.suggester == self || questions.include?(question)
  end
  
  def can_edit_survey?(survey)
    survey.user_id == id
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Emailer.deliver_password_reset_instructions(self)
  end
    
  def find_participation(survey)
    participations.find_by_survey_id(survey)
  end
end
