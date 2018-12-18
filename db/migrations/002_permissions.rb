
Sequel.migration do
  up do
    # Want to avoid allowing NULL for global permissions, so using a 'fake' server entry instead.
    from(:discord_servers).insert(name: 'ISSOLA.GLOBAL', discord_id: '1')

    create_enum(:entity_type, ['user', 'role'])

    create_table :permissions do
      primary_key :id

      foreign_key :discord_server_id, :discord_servers, null: false, on_update: :cascade, on_delete: :cascade

      String      :entity_id,   null: false
      entity_type :entity_type, null: false
      String      :key,         null: false

      index [:key, :entity_id, :discord_server_id], unique: true

      Time :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      Time :updated_at
    end
  end

  down do
    drop_table :permissions
    drop_enum(:entity_type)
    from(:discord_servers).where(discord_id: '1').delete
  end
end

