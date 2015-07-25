Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :username, :null=>false
      String :email
      String :first_name
      String :last_name
      String :password_digest
      String :token
      Boolean :verified, :default => false
    end
  end

  down do
    drop_table(:users)
  end
end