module Watir

  module Clickable
    def click
      @scripter.highlight(self) do
        click_element
      end
    end    
  end

  class HtmlElement
    def_init :parent, :scripter, :how, :what
    attr_reader :how, :what, :parent

    include Locators

    # required by watir specs
    extend ElementAttributes
    html_attr_reader :class_name, "class"
    html_attr_reader :id
    html_attr_reader :name
    html_attr_reader :title
    html_attr_reader :src
    html_attr_reader :alt
    html_method_reader :value

    def type; nil; end

    def is_frame?; false; end

    # overridden in derivitives
    def tag
      raise RuntimeError, "tag not provided for #{element_name}"
    end

    # overridden in derivitives
    def speak
      @scripter.speak("#{element_name}'s don't know how to speak.")
    end

    def exists?
      unless [Fixnum, String, Regexp].any? { |allowed_class| what.kind_of?(allowed_class) }
        raise TypeError.new("May not search using a 'what' value of class #{what.class.name}")
      end
      @scripter.element_exists?(self)
    end
    alias :exist? :exists?
    
    def element_name
      self.class.name.split("::").last
    end

    def html_method name
      @scripter.get_method_value(name, self)
    end

    def attr name
      @scripter.get_attribute(name, self)
    end

    def operate(&block)
      @scripter.operate_by_locator(self, &block)
    end

    OPERATIONS = {
      :id => "by_id",
      :alt => "by_alt",
      :action => "by_action",
      :index => "by_index",
      :class => "by_class",
      :name => "by_name",
      :text => { "Link" => "on_link",
                 "Label" => "by_text",
                 "Span"  => "by_text" },
      :url => "on_link",
      :value => "by_input_value",
      :caption => "by_input_value",
      :src => "by_src",
      :title => "by_title",
      :xpath => "by_xpath",
    }

    def flash
      10.times {@scripter.highlight(self) {sleep 0.05} }
    end

  end

end

# vim:ts=2:sw=2:et:
