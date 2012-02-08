class Class
  def def_init(*attrs)

    # We want the "how" argument to default to :default and the "what"
    # argument to default to nil
    def make_arg(item)
      arg = item.to_s
      case arg
      when 'how'
        arg += '=:default'
      when 'what'
        arg += '=nil'
      end
      return arg
    end

    add_defaults = (attrs[-2] == :how and attrs[-1] == :what)
    $stderr.puts add_defaults.inspect
    constructor = %|def initialize(|
    constructor << attrs.map{|a| add_defaults ? make_arg(a) : a.to_s}.join(",")
    constructor << ")\n"
    attrs.each do |attribute|
      constructor << "@#{attribute} = #{attribute}\n"
    end
    constructor << "end"
    $stderr.puts constructor
    class_eval(constructor)
  end
end

class String
  def quote_safe
    gsub(/"/, '\"')
  end
end

class Object
  def blank?
    if respond_to?(:strip)
      strip.empty?
    elsif respond_to?(:empty?)
      empty?
    else
      !self
    end
  end
end
