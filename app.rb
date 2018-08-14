require 'sinatra'
require 'bcrypt'
require_relative 'dbfunctions.rb'
# require_relative 'user_info.rb'
enable :sessions

# User = Struct.new(:id, :username, :password_hash)
# USERS = [
#  User.new(1, 'ice', hash_password('cream')),
#  User.new(2, 'brownie', hash_password('bites')),
# ]

get '/' do
  # session[:login_name] = params[:login_name]
  # session[:login_password] = params[:login_password]
  message = params[:message] || ""
erb :sign_in, locals:{message:message}
end

post '/create_user' do
  session[:login_name] = params[:login_name]
  session[:login_password] = params[:login_password]
  p "this is sessionnew username #{session[:login_name]}"
  p "this is sessionnew password #{session[:login_password]}"
  db_info = {
    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']
  }

    d_base = PG::Connection.new(db_info)
    encrypted_pass = BCrypt::Password.create(session[:login_password], :cost => 11)
    p "this is encripted pass !!!!!!!!!!!!!!!!!!!!!!!! #{encrypted_pass}"
    checkUser = d_base.exec("SELECT login_name FROM phonebooklogin WHERE login_name = '#{session[:login_name]}'")

    if checkUser.num_tuples.zero? == true
      d_base.exec ("INSERT INTO phonebooklogin (login_name, login_password) VALUES ('#{session[:login_name]}','#{encrypted_pass}')")

      puts "NEW ROW ADDED encripted pass is #{encrypted_pass}"
      redirect "/input_info'#{session[:login_name]}' has been added"
    else
      d_base.close
      puts "NAME ALREADY Exists!!!!!!!!!!!!!!!!!!!!!!"
      redirect '/?message=User Already Exists'
    end

  end

  get '/sign_in' do
    session[:login_name] = params[:login_name]
    session[:login_password] = params[:login_password]

  erb :sign_in, locals:{login_password:session[:login_password], login_name:session[:login_name] }
  end







post '/sign_in' do
  session[:login_name] = params[:login_name]
  session[:login_password] = params[:login_password]
  p "this is sessionnew username #{session[:login_name]}"
  p "this is sessionnew password #{session[:login_password]}"
  db_info = {
    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']
  }

    d_base = PG::Connection.new(db_info)
      # Standard Log In

      user_name = session[:login_name]
      user_pass = session[:login_password]

"this is username and password in sign in #{session[:login_name]} #{session[:login_password]}"
      match_login = d_base.exec("SELECT login_name, login_password FROM phonebooklogin WHERE login_name = '#{session[:login_name]}'")

          if match_login.num_tuples.zero? == true
              error = erb :sign_in,locals: {message:"invalid username and password combination"}
              puts "namepassword combo does not exist"
              return error
          end

      password = match_login[0]['login_password']
      comparePassword = BCrypt::Password.new(password)
      usertype = match_login[0]['usertype']

        if match_login[0]['login_name'] == user_name &&  comparePassword == user_pass
puts "It's a match!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        session[:login_name] = user_name
        # session[:usertype] = usertype
            # session[:email] = email
            erb :input_info
        else
          puts "in the esle, doesn't match"
        erb :sign_in,locals: {message:"invalid username and password combination"}
        end
      # redirect '/'
  end




  # redirect '/input_info'
# end

get '/input_info' do
  erb :input_info
end

post '/input_info' do
  session[:data] = params[:data]
  db_check = check_if_user_is_in_db(session[:data])
  if db_check.num_tuples.zero? == true
    puts "not in db"
    insert_info(session[:data])
    redirect '/final_result'
  else
    puts "it is in the db, search for your listing"
    redirect '/updates'
  end
end

get '/updates' do
  db_check = check_if_user_is_in_db(session[:data]).values[0]
  erb :updates, locals: { db_check: db_check}
end

post '/updates' do
  session[:newdata] = params[:data]
  update_info(session[:newdata],session[:data])
redirect '/final_result'
end

post '/deletes' do
  delete_info(check_if_user_is_in_db(session[:data]).values[0])
  redirect '/final_result'
end


get '/final_result' do
  db_return = select_info()
  erb :final_result, locals: {db_return: db_return}
end

post '/final_result' do
  redirect '/input_info'
end
