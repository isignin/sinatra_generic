require 'sinatra/sequel'
require 'sqlite3'
 
DB=Sequel.sqlite("tmp/generic.db")

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



