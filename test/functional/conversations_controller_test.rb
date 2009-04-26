require File.dirname(__FILE__) + '/../test_helper'
require 'conversations_controller'

# Re-raise errors caught by the controller.
class ConversationsController; def rescue_action(e) raise e end; end

class ConversationsControllerTest < Test::Unit::TestCase
  fixtures :conversations, :contacts, :contacts_conversations, :users

  def setup
    @controller = ConversationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :quentin
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:conversations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_conversation
    old_count = Conversation.count
    xhr(:post, :add_contact, :contact => contacts(:joe))
    post :create, :conversation => { :when_held => Date.new(2007, 7, 28), :title => 'Advice', :details => 'Good advice from Joe...' }
    assert_equal old_count+1, Conversation.count
    assert_redirected_to conversation_path(assigns(:conversation))
  end
  
  def test_should_show_error_for_no_contact
    old_count = Conversation.count
    post :create, :conversation => { :when_held => Date.new(2007, 7, 28), :title => 'Advice', :details => 'Good advice from Joe...' }
    assert_equal old_count, Conversation.count
    assert_response :success
    assert_select "div#errorExplanation" do
      assert_select "h2", /1 error/
    end
    
  end
  
  def test_should_show_errors_for_no_when_held_and_details
    old_count = Conversation.count
    xhr(:post, :add_contact, :contact => contacts(:joe))
    post :create, :conversation => { }
    assert_equal old_count, Conversation.count
    assert_response :success
    assert_select "div#errorExplanation" do
      assert_select "h2", /2 errors/
    end
  end

  def test_should_show_conversation
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_conversation
    put :update, :id => 1, :conversation => { :when_held => Date.new(2007, 7, 19), :title => 'Advice about generating business',
                                              :contacts => [ contacts(:fred) ], :details => 'Blah, blah, blah...' }
    assert_redirected_to conversation_path(assigns(:conversation))
  end
  
  def test_should_destroy_conversation
    old_count = Conversation.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Conversation.count
    
    assert_redirected_to conversations_path
  end
end
