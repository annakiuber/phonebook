require 'pg'
    load './local_env.rb' if File.exist?('./local_env.rb')

def login(data)
  begin
    db_info = {
      host: ENV['RDS_HOST'],
      port: ENV['RDS_PORT'],
      dbname: ENV['RDS_DB_NAME'],
      user: ENV['RDS_USERNAME'],
      password: ENV['RDS_PASSWORD']
      }
    d_base = PG::Connection.new(db_info)
    d_base.exec ("INSERT INTO public.phonebooklogin (username, password) VALUES('#{data[0]}','#{data[1]}');");
    rescue PG::Error => e
      puts e.message
    ensure
      d_base.close if d_base
  end
end

def update_login(data)
  begin
    db_info = {
      host: ENV['RDS_HOST'],
      port: ENV['RDS_PORT'],
      dbname: ENV['RDS_DB_NAME'],
      user: ENV['RDS_USERNAME'],
      password: ENV['RDS_PASSWORD']
      }
    d_base = PG::Connection.new(db_info)
    d_base.exec ("UPDATE public.phonebooklogin
      SET username='#{data[0]}', password='#{data[1]}'");
    rescue PG::Error => e
      puts e.message
    ensure
      d_base.close if d_base
  end
end

def delete_login(data)
  begin
    db_info = {
      host: ENV['RDS_HOST'],
      port: ENV['RDS_PORT'],
      dbname: ENV['RDS_DB_NAME'],
      user: ENV['RDS_USERNAME'],
      password: ENV['RDS_PASSWORD']
      }
    d_base = PG::Connection.new(db_info)
    d_base.exec ("DELETE FROM public.phonebooklogin
      WHERE username='#{data[0]}' AND password='#{data[1]}' ");
    rescue PG::Error => e
      puts e.message
    ensure
      d_base.close if d_base
  end
end

def insert_info(data)
  begin
    db_info = {
      host: ENV['RDS_HOST'],
      port: ENV['RDS_PORT'],
      dbname: ENV['RDS_DB_NAME'],
      user: ENV['RDS_USERNAME'],
      password: ENV['RDS_PASSWORD']
      }
    d_base = PG::Connection.new(db_info)
    d_base.exec ("INSERT INTO public.annaphonebook (first_name, last_name, street_address, city, state, zip_code, phone_number, email_address) VALUES('#{data[0]}','#{data[1]}','#{data[2]}','#{data[3]}','#{data[4]}','#{data[5]}','#{data[6]}', '#{data[7]}');");
    rescue PG::Error => e
      puts e.message
    ensure
      d_base.close if d_base
  end
end

def update_info(data)
  begin
    db_info = {
      host: ENV['RDS_HOST'],
      port: ENV['RDS_PORT'],
      dbname: ENV['RDS_DB_NAME'],
      user: ENV['RDS_USERNAME'],
      password: ENV['RDS_PASSWORD']
      }
    d_base = PG::Connection.new(db_info)
    d_base.exec ("UPDATE public.annaphonebook
      SET first_name='#{data[0]}', last_name='#{data[1]}', street_address='#{data[2]}', city='#{data[3]}', state='#{data[4]}', zip_code='#{data[5]}', phone_number='#{data[6]}', email_address='#{data[7]}'");
    rescue PG::Error => e
      puts e.message
    ensure
      d_base.close if d_base
  end
end

def select_info(data)
  begin
    db_info = {
      host: ENV['RDS_HOST'],
      port: ENV['RDS_PORT'],
      dbname: ENV['RDS_DB_NAME'],
      user: ENV['RDS_USERNAME'],
      password: ENV['RDS_PASSWORD']
      }
    d_base = PG::Connection.new(db_info)
    d_base.exec ("SELECT first_name, last_name, street_address, city, state, zip_code, phone_number, email_address
      FROM public.annaphonebook");
    rescue PG::Error => e
      puts e.message
    ensure
      d_base.close if d_base
  end
end

def check_if_user_is_in_db(data)
  begin
    db_info = {
    host: ENV['RDS_HOST'],
    port: ENV['RDS_PORT'],
    dbname: ENV['RDS_DB_NAME'],
    user: ENV['RDS_USERNAME'],
    password: ENV['RDS_PASSWORD']
    }
    d_base = PG::Connection.new(db_info)
    d_base.exec ("SELECT * FROM public.annaphonebook WHERE email_address = '#{data[7]}';")
  rescue PG::Error => e
    puts e.message
    ensure
    d_base.close if d_base
  end
end

def delete_info(data)
  begin
    db_info = {
      host: ENV['RDS_HOST'],
      port: ENV['RDS_PORT'],
      dbname: ENV['RDS_DB_NAME'],
      user: ENV['RDS_USERNAME'],
      password: ENV['RDS_PASSWORD']
      }
    d_base = PG::Connection.new(db_info)
    d_base.exec ("DELETE FROM public.annaphonebook
      WHERE first_name='#{data[0]}' AND last_name='#{data[1]}' AND street_address='#{data[2]}' AND city='#{data[3]}' AND state='#{data[4]}' AND zip_code='#{data[5]}' AND phone_number='#{data[6]}' AND email_address='#{data[7]}'");
    rescue PG::Error => e
      puts e.message
    ensure
      d_base.close if d_base
  end
end
