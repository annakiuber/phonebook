require 'bcrypt'
    load './local_env.rb' if File.exist?('./local_env.rb')

def current_user
  if session[:user_id]
     USERS.find { |u| u.id == session[:user_id] }
  else
    nil
  end
end

def hash_password(password)
  BCrypt::Password.create(password).to_s
end

def test_password(password, hash)
  BCrypt::Password.new(hash) == password
end
