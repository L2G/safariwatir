module Watir

  class InputElement < HtmlElement
    include Clickable
    
    html_attr_reader :type

    def speak
      @scripter.speak_value_of(self)
    end
    
    def enabled?
      !@scripter.element_disabled?(self)
    end
    
    def disabled?
      @scripter.element_disabled?(self)
    end

    def tag; "INPUT"; end

    # Hook for derivitives
    def by_value; end
  end
    
  class SelectList < InputElement
    def select(label)
      option(:text, label).select
    end
    
    def select_value(value)
      option(:value, value).select
    end
    
    def option(how, what)
      Option.new(@scripter, self, how, what)
    end

    def selected_values
      values = []
      index = 1
      loop do
        option = option(:index, index)
        break unless option.exists?
        values << option if option.selected?
        index += 1
      end
      values.map {|o| o.text } #TODO?
    end

    alias :selected_options :selected_values

    def selected_value
      selected_values.first
    end
    
    def speak
      @scripter.speak_options_for(self)
    end
    
    def tag; "SELECT"; end
  end

  class Option < InputElement
    def_init :scripter, :select_list, :how, :what
    def parent; @select_list; end

    def selected?
      selected_value = html_method(:selected) ? html_method(:selected) : ""
      selected_value != ""
    end

    def select
      @scripter.highlight(self) do
        select_option
      end
    end
    
    def text
      @scripter.get_text_for(self)
    end

    def tag; "OPTION"; end
  end

  class Button < InputElement
    def tag; ["INPUT", "BUTTON"]; end
    include ButtonLocators
  end
      
  class TextField < InputElement
    include InputLocators
    def input_type; "text"; end

    def set(value)
      value = value.to_s
      @scripter.focus(self)
      @scripter.highlight(self) do
        clear_text_input
        value.length.times do |i|
          append_text_input(value[i, 1])
        end
      end
      @scripter.blur(self)
    end
    
    def getContents
      @scripter.get_value_for(self)
    end

    alias :value :getContents
    
    def verify_contains(expected)
      actual = getContents
      case expected
      when Regexp
        actual.match(expected) != nil
      else
        expected == actual
      end
    end
  end
  
  class TextArea < TextField
    def tag; ["input", "textarea"]; end
  end

  class TextArea2 < InputElement
    def tag; ["textarea"]; end

    def set(value)
      value = value.to_s
      @scripter.focus(self)
      @scripter.highlight(self) do
        clear_text_input
        value.length.times do |i|
          append_text_input(value[i, 1])
        end
      end
      @scripter.blur(self)
    end

    def getContents
      @scripter.get_value_for(self)
    end

    alias :value :getContents

    def verify_contains(expected)
      actual = getContents
      case expected
      when Regexp
        actual.match(expected) != nil
      else
        expected == actual
      end
    end
  end

  class Checkbox < InputElement
    def_init :parent, :scripter, :how, :what, :value
    
    include InputLocators

    def input_type; "checkbox"; end

    def by_value
      @value
    end

    # Contributed by Kyle Campos
    def checked?
      @scripter.checkbox_is_checked?(self)
    end
    
    def set(check_it = true)
      return if check_it && checked?
      return if !check_it && !checked?
      click
    end
  end

  class Radio < Checkbox
    def input_type; "radio"; end
  end


end


# vim:ts=2:sw=2:et:
