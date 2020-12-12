module NextInPlace
  module ViewHelpers
    def next_in_place(object, field, settings = {})
      # TODO: Add handling for display_with or display_as options to format the out put values correctly....
      attribute_value = object.send(field)

      display_value = set_display_value(object, attribute_value, settings[:display_with])

      field = field.to_s

      # to do - convert this to use a config variable instead as the default...
      type = settings[:type] || :input

      html_attrs = settings[:html_attrs].to_h { |k, v| [k.to_s, v.to_s] }

      # TODO: add method to handle different formats of input of the options collection....
      collection = settings[:collection].to_h { |k, v| [k.to_s, v.to_s] }

      options = {}
      options[:data] = {}
      options[:class] = settings[:class] # expand to add next_in_place automatically along with any custom classes provided
      options[:id] = "nip-#{object.id}-#{object.class.to_s.downcase}"
      options[:data]['nip-type'] = settings[:type] || 'input'
      options[:data]['nip-attribute'] = field
      options[:data]['nip-object'] = object.class.to_s.downcase
      options[:data]['nip-original-value'] = attribute_value.to_s
      options[:data]['nip-value'] = attribute_value.to_s
      options[:data]['nip-html-attrs'] = html_attrs if html_attrs.any?
      options[:data]['nip-collection'] = collection if collection.any?

      content_tag :span, class: 'nip-wrapper' do
        content_tag :span, display_value, options
      end
    end

    def next_in_place_if(condition, object, field, settings = {})
      if condition == true
        next_in_place(object, field, settings)
      else
        # TODO: determine plan for handling whe the condition is not met...
      end
    end

    def set_display_value(object, val, display_with = nil)
      if display_with
        if respond_to? display_with.to_sym
          send(display_with, val)
        else
          object.send(display_with, val)
        end

      else
        val.to_s
      end
    end
  end
end
