class CreateModels < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :name
      t.string    :email,               :null => false                # optional, you can use login instead, or both
      t.string    :crypted_password,    :null => false                # optional, see below
      t.string    :password_salt,       :null => false                # optional, but highly recommended
      t.string    :persistence_token,   :null => false                # required
      t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability

      # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
      t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip
      t.timestamps
    end
    
    add_index :users, :email
    add_index :users, :persistence_token
    add_index :users, :last_request_at
    
    create_table :surveys do |t|
      t.integer :category_id, :user_id
      t.string :title
      t.text :description
      t.integer :questions_count, :default => 0
      t.timestamps
    end
    
    add_index :surveys, :category_id
    add_index :surveys, :user_id
    
    create_table :questions do |t|
      t.integer :survey_id
      t.text :body
      t.integer :answers_count, :default => 0
      t.integer :position
      t.timestamps
    end
    
    add_index :questions, :survey_id
    
    create_table :answers do |t|
      t.integer :question_id
      t.text :body
      t.boolean :correct, :default => false
      t.integer :position
      t.timestamps
    end
    
    add_index :answers, :question_id
    
    create_table :categories do |t|
      t.string :name
      t.integer :surveys_count, :default => 0
      t.timestamps
    end
    
    add_index :categories, :name
    
    create_table :participations do |t|
      t.integer :user_id, :survey_id
      t.integer :correct_count, :incorrect_count, :default => 0
      t.timestamps
    end
    
    add_index :participations, [:user_id, :survey_id]
    
    create_table :user_answers do |t|
      t.integer :user_id, :question_id, :answer_id
      t.boolean :correct, :default => false
      t.timestamps
    end
    
    add_index :user_answers, :user_id
    add_index :user_answers, :question_id
    add_index :user_answers, :answer_id
  end

  def self.down
    drop_table :users
    drop_table :surveys
    drop_table :questions
    drop_table :answers
    drop_table :categories
    drop_table :participations
    drop_table :user_answers
  end
end
