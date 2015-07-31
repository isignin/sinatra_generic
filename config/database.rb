require 'sinatra/sequel'
require 'sqlite3'

DB = case ENV['RACK_ENV']
  when 'test' then Sequel.sqlite
  when 'production' then Sequel.sqlite("tmp/generic_production.db") 
  else Sequel.sqlite("tmp/generic.db")  # development
end

unless DB.table_exists?(:users)
  DB.create_table :users do
    primary_key :id
    String :username
    String :email
    String :first_name
    String :last_name
    String :password_digest
    String :token
    Integer :verified, :default => false
   end
end



