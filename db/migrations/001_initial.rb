Sequel.migration do
  up do
    create_table :discord_users do
      primary_key :id

      String :last_nick,  null: false
      # Based on Twitter's snowflake format https://github.com/twitter/snowflake/tree/snowflake-2010
      String :discord_id, null: false, unique: true

      Time :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      Time :updated_at
    end
  end

  down do
    drop_table :discord_users
  end
end

