class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
      t.column :when_held, :date
      t.column :title, :string
      t.column :details, :text
    end
  end

  def self.down
    drop_table :conversations
  end
end
