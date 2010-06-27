# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

me = User.create :name => 'Justin Ko',
                 :username => 'test',
                 :email => 'test@test.com',
                 :password => 'test',
                 :password_confirmation => 'test'

dhh = User.create :name => 'David Hanson',
                  :username => 'dhh',
                  :email => 'dhh@test.com',
                  :password => 'test',
                  :password_confirmation => 'test'            
            
['Ruby', 'Scala', 'Erlang'].each do |name|
  Category.create :name => name
end

q = Survey.new :title => 'Ruby on Rails',
             :category => Category.find_by_name('Programming')
q.user = me
q.save
            
q = Survey.new :title => 'Checking and Savings',
             :category => Category.find_by_name('Finance')
q.user = dhh
q.save

survey1 = Survey.find_by_title('Ruby on Rails')

q = Question.new :body => 'What is a polymorphic relationship?'
q.survey = survey1
q.save

survey2 = Survey.find_by_title('Checking and Savings')

question1 = Question.new :body => 'Should you ever pay over draft fees?'
question1.survey = survey2
question1.save

a = Answer.new :body => 'Yes'
a.question = question1
a.save

a = Answer.new :body => 'No'
a.question = question1
a.save