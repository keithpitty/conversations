require File.dirname(__FILE__) + '/../test_helper'

class ContactTest < Test::Unit::TestCase
  fixtures :conversations, :contacts, :contacts_conversations

  def test_read_all_contacts
    contacts = Contact.find(:all)
    assert_equal 3, contacts.size
  end
  
  def test_read_first_contact
    contact = Contact.find(1)
    assert_equal 'Fred', contact.first_name
    assert_equal 'Bloggs', contact.last_name
    assert_equal 'Megabucks Inc.', contact.organisation
    assert_equal 'Good source of advice on making money.', contact.notes
  end
  
  def test_create_contact
    contact = Contact.new
    contact.first_name = 'John'
    contact.last_name = 'Smith'
    contact.save
    contacts = Contact.find(:all)
    assert_equal 4, contacts.size
    retrieved_contact = Contact.find(contact.id)
    assert_equal 'John', retrieved_contact.first_name
    assert_equal 'Smith', retrieved_contact.last_name
  end
  
  def test_update_contact
    contact = Contact.find(2)
    contact.notes = 'Trustworthy bloke who builds good software.'
    contact.save
    retrieved_contact = Contact.find(2)
    assert_equal 'Trustworthy bloke who builds good software.', retrieved_contact.notes
  end
  
  def test_delete_contact_should_fail
    contact = Contact.find(2)
    contact.destroy
    contacts = Contact.find(:all)
    assert_equal 3, contacts.size
  end
  
  def test_delete_contact_should_succeed
    contact = Contact.find(3)
    contact.destroy
    contacts = Contact.find(:all)
    assert_equal 2, contacts.size
  end
end
