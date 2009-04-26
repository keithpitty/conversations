class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :organisation, :string
      t.column :notes, :text
    end
  end

  def self.down
    drop_table :contacts
  end
end
