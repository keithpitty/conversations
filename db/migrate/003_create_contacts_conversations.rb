class CreateContactsConversations < ActiveRecord::Migration
  def self.up
    create_table :contacts_conversations, :id => false do |t|
      t.column :contact_id, :integer
      t.column :conversation_id, :integer
    end
  end

  def self.down
    drop_table :contacts_conversations
  end
end
