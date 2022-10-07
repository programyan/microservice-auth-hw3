Sequel.migration do
  up do
    execute 'CREATE EXTENSION IF NOT EXISTS citext;'

    create_table :users do |t|
      primary_key :id
      String :name, null: false
      column :email, :citext, null: false, index: { unique: true }
      String :password_digest, null: false
      column :created_at, 'timestamp without time zone', null: false
      column :updated_at, 'timestamp without time zone', null: false
    end

    create_table :user_sessions do |t|
      primary_key :id
      column :uuid, :uuid, null: false, index: true
      foreign_key :user_id, :users, null: false

      column :created_at, 'timestamp without time zone', null: false
      column :updated_at, 'timestamp without time zone', null: false
    end
  end

  down do
    drop_table :user_sessions
    drop_table :users

    execute 'DROP EXTENSION citext;'
  end
end
