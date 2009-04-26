require File.dirname(__FILE__) + '/../test_helper'
require 'reminders_controller'

# Re-raise errors caught by the controller.
class RemindersController; def rescue_action(e) raise e end; end

class RemindersControllerTest < Test::Unit::TestCase
  fixtures :reminders, :contacts, :contacts_reminders, :users

  def setup
    @controller = RemindersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :quentin
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:reminders)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_reminder
    old_count = Reminder.count
    xhr(:post, :add_contact, :contact => contacts(:joe))
    post :create, :reminder => { :when_due => Time.now.to_date + 7.days, :title => 'Call Joe', :details => 'Latest news' }
    assert_equal old_count+1, Reminder.count
    
    assert_redirected_to reminder_path(assigns(:reminder))
  end

  def test_should_show_error_for_no_contact
    old_count = Reminder.count
    post :create, :reminder => { :when_due => Time.now.to_date + 7.days, :title => 'Call Joe', :details => 'Advice re project' }
    assert_equal old_count, Reminder.count
    assert_response :success
    assert_select "div#errorExplanation" do
      assert_select "h2", /1 error/
    end
  end

  def test_should_show_errors_for_no_when_due_and_details
    old_count = Reminder.count
    xhr(:post, :add_contact, :contact => contacts(:joe))
    post :create, :reminder => { }
    assert_equal old_count, Reminder.count
    assert_response :success
    assert_select "div#errorExplanation" do
      assert_select "h2", /2 errors/
    end
  end
  
  def test_should_show_error_for_when_due_in_past
    old_count = Reminder.count
    xhr(:post, :add_contact, :contact => contacts(:joe))
    post :create, :reminder => { :when_due => Time.now.to_date - 7.days, :title => 'Call Joe', :details => 'Advice re project' }
    assert_equal old_count, Reminder.count
    assert_response :success
    assert_select "div#errorExplanation" do
      assert_select "h2", /1 error/
    end
  end

  def test_should_show_reminder
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_reminder
    put :update, :id => 1, :reminder => { }
    assert_redirected_to reminder_path(assigns(:reminder))
  end
  
  def test_should_destroy_reminder
    old_count = Reminder.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Reminder.count
    
    assert_redirected_to reminders_path
  end
end
