require File.dirname(__FILE__) + '/../test_helper'

class ConversationTest < Test::Unit::TestCase
  fixtures :conversations, :contacts, :contacts_conversations

  def test_create_conversation
    conversation = Conversation.new
    conversation.when_held = Date.new(2007, 7, 27)
    conversation.title = 'More advice'
    conversation.details = 'Got advice about stuff.'
    conversation.contacts << Contact.find(2)
    conversation.save
    conversations = Conversation.find(:all)
    assert_equal 4, conversations.size
    retrieved_conversation = Conversation.find(conversation.id)
    assert_equal Date.new(2007, 7, 27), retrieved_conversation.when_held
    assert_equal 'More advice', retrieved_conversation.title
    assert_equal 'Got advice about stuff.', retrieved_conversation.details
    assert_equal 1, retrieved_conversation.contacts.size
    assert_equal Contact.find(2), retrieved_conversation.contacts.first
  end
  
  def test_read_all_conversations
    conversations = Conversation.find(:all)
    assert_equal 3, conversations.size
  end
  
  def test_read_third_conversation
    conversation = Conversation.find(3)
    assert_equal 2, conversation.contacts.size
    assert_equal Date.new(2007, 7, 26), conversation.when_held
    assert_equal 'Advice about launching my business', conversation.title
    assert_equal 'Received valuable advice from Fred and Joe about how to best launch by business.', conversation.details
  end
  
  def test_update_conversation
    conversation = Conversation.find(3)
    conversation.when_held = Date.new(2007, 7, 28)
    conversation.save
    updated_conversation = Conversation.find(3)
    assert_equal Date.new(2007, 7, 28), updated_conversation.when_held
  end
  
  def test_delete_conversation
    conversation = Conversation.find(3)
    conversation.destroy
    conversations = Conversation.find(:all)
    assert_equal 2, conversations.size
  end
end
