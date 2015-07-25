class User < Sequel::Model
  plugin :validation_helpers
  plugin :secure_password
  
  def validate
    super
    validates_presence [:username, :email, :first_name, :last_name]
    validates_unique [:username, :email]
  end
    
end
