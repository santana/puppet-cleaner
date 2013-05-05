module Puppet::Cleaner
  class ResourceTitles < Worker
    def part_names
      [:LBRACE]
    end
  
    def operate(line)
      pos = line.position - 1
      pos -= 1 while [:BLANK, :RETURN, :COMMENT, :MLCOMMENT].include?(line.parts[pos].name) && pos >= 0
      return if pos < 0 || ![:NAME, :CLASS].include?(line.parts[pos].name)

      pos -= 1
      pos -= 1 while [:BLANK, :RETURN, :COMMENT, :MLCOMMENT].include?(line.parts[pos].name) && pos >= 0
      return if [:CASE, :IF].include?(line.parts[pos].name)

      foreach_title(line) do |pos|
        if [:NAME, :CLASSREF].include?(line.parts[pos].name)
          line.parts[pos] = Part.create([:STRING, {:value => line.parts[pos].value}])
        end
      end
    end
  
    def foreach_title(line)
      depth = 1
      pos = line.position
  
      loop do
        pos += 1
        break if depth == 0 || pos >= line.parts.size
        case line.parts[pos].name
        when :LBRACE
          depth += 1
        when :RBRACE
          depth -= 1
        when :COLON
          next if depth != 1
          yield pos - 1
        end
      end
    end
  end
end # module
