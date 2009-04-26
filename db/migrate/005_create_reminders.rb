class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.column :when_due, :date
      t.column :title, :string
      t.column :details, :text
    end
    create_table :contacts_reminders, :id => false do |t|
      t.column :contact_id, :integer
      t.column :reminder_id, :integer
    end
  end

  def self.down
    drop_table :contacts_reminders
    drop_table :reminders
  end
end
