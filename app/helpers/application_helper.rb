# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def label_and_value(label, value)
    content_tag(:p, content_tag(:span, label, :class => "strong") + value)
  end
  
  def label_and_contact_links(label, contacts)
    result = '<p><span class="strong">' + label + '</span>'
    i = 0
    contacts.each do |contact|
      result << '<a href="'
      result << contact_path(contact)
      result << '">'
      result << contact.full_name
      result << '</a>'
      i += 1
      if i < contacts.size
        result << ', '
      end
    end
    result << '</p>'
  end
  
  def tagged_form_for(name, *args, &block)
    options = args.last.is_a?(Hash) ? args.pop : {}
    options = options.merge(:builder => TaggedBuilder)
    args = (args << options)
    form_for(name, *args, &block)
  end
  
  def string_as_paras(name)
    paras = name.split("\r\n")
    result = ""
    first = true
    paras.each do |para| 
      if first
        result << para
        first = false
      else
        result << "<p>" + para + "</p>"
      end
    end
    result
  end
  
  def spanned_image_and_link_to(image_file_name, *args)
    content_tag(:span, image_and_link_to(image_file_name, *args), :class => "imageAndLinks")
  end
  
  def image_and_link_to(image_file_name, *args)
    html = [image_tag(image_file_name)]
    html << link_to(*args)
    html.join(' ')
  end
  
  def new_conversation_with_contact_path(contact)
    new_conversation_path + "/" + contact.id.to_s
  end
  
  def new_reminder_for_contact_path(contact)
    new_reminder_path + "/" + contact.id.to_s
  end
end

class TaggedBuilder < ActionView::Helpers::FormBuilder
  
  # <p>
  #   <label for="contact_notes">Notes</label><br />
  #   <%= form.text_area 'notes' %>
  # </p>
  
  def self.create_tagged_field(method_name)
    define_method(method_name) do |label, *args|
      @template.content_tag(:p, @template.content_tag(:label, label.to_s.humanize + required_tag(*args)) + "<br />" + super)
    end
  end
  
  field_helpers.each do |name|
    create_tagged_field(name)
  end
  
  def date_select(label, *args)
    @template.content_tag(:p, @template.content_tag(:label, label.to_s.humanize + required_tag(*args)) + "<br />" + super)
  end
  
  def required_tag(*args)
    required?(*args) ? " " + @template.content_tag(:em, "(required)", :class => "required") : ""
  end
  
  def required?(*args)
    args.last != nil && args.last.is_a?(Hash) && args.last.has_key?(:required) && args.last.key?(:required)
  end
  
end
