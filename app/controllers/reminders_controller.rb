class RemindersController < ApplicationController
  before_filter :login_required
  # GET /reminders
  # GET /reminders.xml
  def index
    @reminders = Reminder.paginate :page => params[:page], :order => "when_due asc", :per_page => 15

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @reminders.to_xml }
    end
  end

  # GET /reminders/1
  # GET /reminders/1.xml
  def show
    @reminder = Reminder.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @reminder.to_xml }
    end
  end

  # GET /reminders/new
  def new
    @reminder = Reminder.new
    @contacts = Contact.find(:all, :order => "last_name")
    @reminder.contacts = []
    @reminder.contacts << Contact.find(params[:id]) unless params[:id].blank?
    contact_ids = []
    contact_ids << params[:id] unless params[:id].blank?
    session[:contacts_for_reminder] = contact_ids
  end

  # GET /reminders/1;edit
  def edit
    @reminder = Reminder.find(params[:id])
    @contacts = Contact.find(:all, :order => "last_name")
    contact_ids = []
    @reminder.contacts.each {|contact| contact_ids << contact.id }
    session[:contacts_for_reminder] = contact_ids
  end

  # POST /reminders
  # POST /reminders.xml
  def create
    @reminder = Reminder.new(params[:reminder])
    if session[:contacts_for_reminder].blank?
      @reminder.contacts = []
      @reminder.errors.add_to_base("You must specify at least one contact.")
    elsif @reminder.valid? && @reminder.when_due < Time.now.to_date
      @reminder.contacts = []
      @reminder.errors.add_to_base("Due date cannot be in the past.")
    else
      @reminder.contacts = contacts_from_ids(session[:contacts_for_reminder])
    end

    respond_to do |format|
      if @reminder.errors.blank? && @reminder.save
        flash[:notice] = 'Reminder was successfully created.'
        format.html { redirect_to reminder_url(@reminder) }
        format.xml  { head :created, :location => reminder(@reminder) }
      else
        @contacts = Contact.find(:all, :order => "last_name")
        format.html { render :action => "new" }
        format.xml  { render :xml => @reminder.errors.to_xml }
      end
    end
  end

  # PUT /reminders/1
  # PUT /reminders/1.xml
  def update
    @reminder = Reminder.find(params[:id])

    respond_to do |format|
      if @reminder.update_attributes(params[:reminder])
        flash[:notice] = 'Reminder was successfully updated.'
        format.html { redirect_to reminder_url(@reminder) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reminder.errors.to_xml }
      end
    end
  end

  # DELETE /reminders/1
  # DELETE /reminders/1.xml
  def destroy
    @reminder = Reminder.find(params[:id])
    @reminder.destroy

    respond_to do |format|
      format.html { redirect_to reminders_url }
      format.xml  { head :ok }
    end
  end
  
  def add_contact
    contact_to_add = Contact.find(params[:contact][:id])
    contacts_for_reminder = contacts_from_ids(session[:contacts_for_reminder])
    if contacts_for_reminder == nil
      contacts_for_reminder = []
    end
    unless contacts_for_reminder.include? contact_to_add
      contacts_for_reminder << contact_to_add
    end
    render_contacts_for_reminder(contacts_for_reminder)
  end
  
  def delete_contact
    contact_to_delete = Contact.find(params[:id])
    contacts_for_reminder = contacts_from_ids(session[:contacts_for_reminder])
    contacts_for_reminder = contacts_for_reminder.reject { |contact| contact == contact_to_delete }
    render_contacts_for_reminder(contacts_for_reminder)
  end
  
  private
  
  def render_contacts_for_reminder(contacts)
    contact_ids = []
    contacts.each {|contact| contact_ids << contact.id }
    session[:contacts_for_reminder] = contact_ids
    render :partial => "contacts_for_reminder", :locals =>  { :contacts => contacts }
  end

  def contacts_from_ids(contact_ids)
    contacts = []
    contact_ids.each {|id| contacts << Contact.find(id) } if contact_ids && contact_ids.any?
    contacts
  end
  
end
