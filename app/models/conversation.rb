class Conversation < ActiveRecord::Base
  has_and_belongs_to_many :contacts
  validates_presence_of :when_held, :details
  
  def when_and_who
    when_held_as_string + " with " + contacts_as_string
  end
  
  def when_held_as_string
    when_held.strftime('%d/%m/%y')
  end
  
  def when_and_about
    when_held_as_string + " - " + title
  end
  
  def contacts_as_string
    if contacts.size > 0
      result = ""
      i = 0
      contacts.each do |contact|
        i += 1
        result << contact.full_name 
        if i < contacts.size
          result << ", "
        end
      end
      result
    else
      ""
    end
  end
  
end
