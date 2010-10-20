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