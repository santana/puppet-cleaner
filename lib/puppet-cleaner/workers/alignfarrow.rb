module Puppet::Cleaner
  class AlignFarrow < Worker
    def part_names
      [:LBRACE]
    end
  
    def operate(line)
      max, params = get_params(line)
      params.each do |param|
        nblanks = max - param[:name].to_s.size + 1
        param[:before].value = ' '*nblanks if param[:before].value.size != nblanks
      end
    end
  
    def get_params(line)
      depth = 1
      max = 0
      pos = line.position
      params = []
  
      loop do
        pos += 1
        break if depth == 0 || pos >= line.parts.size
        case line.parts[pos].name
        when :LBRACE
          depth += 1
        when :RBRACE
          depth -= 1
        when :FARROW
          next if depth != 1
  
          if line.parts[pos - 1].name == :BLANK
            name = line.parts[pos - 2]
            before = line.parts[pos - 1]
          else
            name = line.parts[pos - 1]
            before = Part.create([:BLANK, {:value => ''}])
            line.insert(pos, [before])
            pos += 1
          end
  
          if line.parts[pos + 1].name == :BLANK
            line.parts[pos + 1].value = ' ' if line.parts[pos + 1].value != ' '
          else
            line.append(pos, Part.create([:BLANK, {:value => ' '}]))
          end
  
          max = name.to_s.size if name.to_s.size > max
          params << {:name => name, :before => before}
        end
      end
      [max, params]
    end
  end
end # module
