require File.dirname(__FILE__) + '/../test_helper'

class ReminderTest < Test::Unit::TestCase
  fixtures :reminders

  def test_create_reminder
    reminder = Reminder.new
    reminder.when_due = Date.new(2008, 2, 1)
    reminder.title = 'Stuff'
    reminder.details = 'More detailed stuff'
    reminder.contacts << Contact.find(1)
    reminder.save
    reminders = Reminder.find(:all)
    assert_equal 2, reminders.size
    retrieved_reminder = Reminder.find(reminder.id)
    assert_equal Date.new(2008, 2, 1), retrieved_reminder.when_due
    assert_equal 'Stuff', retrieved_reminder.title
    assert_equal 'More detailed stuff', retrieved_reminder.details
    assert_equal 1, retrieved_reminder.contacts.size
    assert_equal reminder.contacts.first, retrieved_reminder.contacts.first
  end
  
  def test_read_all_reminders
    reminders = Reminder.find(:all)
    assert_equal 1, reminders.size
    reminder = reminders.first
    assert_equal Date.new(2008, 2, 1), reminder.when_due
    assert_equal 'Review', reminder.title
    assert_equal 'Catch up to review progress.', reminder.details
  end
  
  def test_update_reminder
    reminder = Reminder.find(1)
    reminder.when_due = Date.new(2008, 3, 1)
    reminder.save
    updated_reminder = Reminder.find(1)
    assert_equal Date.new(2008, 3, 1), updated_reminder.when_due
  end
  
  def test_delete_reminder
    reminder = Reminder.find(1)
    reminder.destroy
    reminders = Reminder.find(:all)
    assert_equal 0, reminders.size
  end
end
