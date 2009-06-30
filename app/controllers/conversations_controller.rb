class ConversationsController < ApplicationController
  before_filter :login_required
  
  # GET /conversations
  # GET /conversations.xml
  def index
    if Reminder.count > 0 && session[:just_logged_in]
      session[:just_logged_in] = nil
      redirect_to reminders_path
    else
      @conversations = Conversation.paginate :page => params[:page], :order => "when_held desc", :per_page => 15

      respond_to do |format|
        format.html # index.rhtml
        format.xml  { render :xml => @conversations.to_xml }
      end
    end
  end

  # GET /conversations/1
  # GET /conversations/1.xml
  def show
    @conversation = Conversation.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @conversation.to_xml }
    end
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
    @contacts = Contact.find(:all, :order => "last_name")
    @conversation.contacts = []
    @conversation.contacts << Contact.find(params[:id]) unless params[:id].blank?
    contact_ids = []
    contact_ids << params[:id] unless params[:id].blank?
    session[:contacts_in_conversation] = contact_ids
  end

  # GET /conversations/1;edit
  def edit
    @conversation = Conversation.find(params[:id])
    @contacts = Contact.find(:all, :order => "last_name")
    contact_ids = []
    @conversation.contacts.each {|contact| contact_ids << contact.id }
    session[:contacts_in_conversation] = contact_ids
  end

  # POST /conversations
  # POST /conversations.xml
  def create
    @conversation = Conversation.new(params[:conversation])
    if session[:contacts_in_conversation].blank?
      @conversation.contacts = []
      @conversation.errors.add_to_base("You must specify at least one contact.")
    else
      @conversation.contacts = contacts_from_ids(session[:contacts_in_conversation])
    end

    respond_to do |format|
      if @conversation.errors.blank? && @conversation.save
        flash[:notice] = 'Conversation was successfully created.'
        format.html { redirect_to conversation_url(@conversation) }
        format.xml  { head :created, :location => conversation_url(@conversation) }
      else
        @contacts = Contact.find(:all, :order => "last_name")
        format.html { render :action => "new" }
        format.xml  { render :xml => @conversation.errors.to_xml }
      end
    end
  end

  # PUT /conversations/1
  # PUT /conversations/1.xml
  def update
    @conversation = Conversation.find(params[:id])

    respond_to do |format|
      if @conversation.update_attributes(params[:conversation])
        flash[:notice] = 'Conversation was successfully updated.'
        format.html { redirect_to conversation_url(@conversation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conversation.errors.to_xml }
      end
    end
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.xml
  def destroy
    @conversation = Conversation.find(params[:id])
    @conversation.destroy

    respond_to do |format|
      format.html { redirect_to conversations_url }
      format.xml  { head :ok }
    end
  end
  
  def add_contact
    contact_to_add = Contact.find(params[:contact][:id])
    contacts_in_conversation = contacts_from_ids(session[:contacts_in_conversation])
    unless contacts_in_conversation.include? contact_to_add
      contacts_in_conversation << contact_to_add
    end
    render_contacts_in_conversation(contacts_in_conversation)
  end
  
  def delete_contact
    contact_to_delete = Contact.find(params[:id])
    contacts_in_conversation = contacts_from_ids(session[:contacts_in_conversation])
    contacts_in_conversation = contacts_in_conversation.reject { |contact| contact == contact_to_delete }
    render_contacts_in_conversation(contacts_in_conversation)
  end
  
  private
  
  def render_contacts_in_conversation(contacts)
    contact_ids = []
    contacts.each {|contact| contact_ids << contact.id }
    session[:contacts_in_conversation] = contact_ids
    render :partial => "contacts_in_conversation", :locals => { :contacts => contacts }
  end
  
  def contacts_from_ids(contact_ids)
    contacts = []
    contact_ids.each {|id| contacts << Contact.find(id) } if contact_ids && contact_ids.any?
    contacts
  end
end
