class Contact < ActiveRecord::Base
  has_and_belongs_to_many :conversations, :order => "when_held desc"
  has_and_belongs_to_many :reminders, :order => "when_due desc"
  validates_presence_of :first_name, :last_name
  
  def before_destroy
    if !conversations.blank?
      errors.add_to_base("You cannot delete a contact that has conversations.")
      false
    end
  end
  
  def full_name
    first_name + " " + last_name
  end
end
