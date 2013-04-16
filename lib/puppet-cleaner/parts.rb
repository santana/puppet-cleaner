module Puppet::Cleaner
  class Part
    # what makes a double quote string special
    DQSPECIAL = {
      "\n" => "\\n",
      "\r" => "\\r",
      "\t" => "\\t"
    }

    DQESCAPE = DQSPECIAL.dup
    DQESCAPE["\""] = "\\\""
    DQESCAPE["\\"] = "\\\\"
    DQESCAPE["$"] = "\\$"

    SQESCAPE = {
      "'" => "\\'"
    }

    DQPATTERN = /[#{DQESCAPE.keys.map{|key| key.inspect[1..-2]}.join}]/
    SQPATTERN = /[#{SQESCAPE.keys.map{|key| key.inspect[1..-2]}.join}]/

    SPECIAL_ESCAPE_SEQUENCES = /[#{DQSPECIAL.keys.map{|key| key.inspect[1..-2]}.join}]/

    def self.create(raw)
      begin
        klass = Puppet::Cleaner.const_get(raw[0].to_s.capitalize.to_sym)
        klass.new(raw)
      rescue NameError => e
        Part.new(raw)
      end
    end

    def initialize(raw)
      @raw = raw
    end

    def has_special_escape_sequences?
      value =~ SPECIAL_ESCAPE_SEQUENCES
    end

    def show(context)
      print to_s
    end

    def name
      @raw[0]
    end

    def name=(name)
      @raw[0] = name
    end

    def to_s
      value.to_s
    end

    def value
      @raw[1][:value]
    end

    def value=(value)
      @raw[1][:value] = value
    end

    def dqescape
      value.gsub(Part::DQPATTERN) {|match| Part::DQESCAPE[match]}
    end

    def sqescape
      ret = value.gsub(Part::SQPATTERN) {|match| Part::SQESCAPE[match]}
      ret =~ /\\+$/
      ret += "\\" if $& && $&.size % 2 == 1
      ret
    end

  end

  class Variable < Part
    def to_s
      "$#{value}"
    end

    def show(context)
      if [:DQPRE, :DQMID].include?(context[:before].name)
        print value
      else
        super
      end
    end
  end

  class Comment < Part
    def to_s
      value.empty? ? "#" : "# #{value}"
    end
  end

  class Mlcomment < Part
    def to_s
      "/*#{value}*/"
    end
  end

  class Dqpre < Part
    def to_s
      "\"#{dqescape}${"
    end
  end

  class Dqmid < Part
    def to_s
      "}#{dqescape}${"
    end
  end

  class Dqpost < Part
    def to_s
      "}#{dqescape}\""
    end
  end

  class String < Part
    def to_s
      has_special_escape_sequences? ? "\"#{dqescape}\"" : "'#{sqescape}'"
    end
  end

  class Class < Part; end

  class Regex < Part
    def to_s
      value.inspect
    end
  end

  NoPart = Part.new([:NOPART, {:value => ""}])
end
