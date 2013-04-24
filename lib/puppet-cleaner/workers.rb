module Puppet::Cleaner
  class Worker
    def part_names
      raise "Must be implemented in subclass"
    end
  
    def operate
      raise "Must be implemented in subclass"
    end
  
    def get_param(line, param_name, pos)
      depth = 1
  
      loop do
        pos += 1
        break if depth == 0 || pos >= line.parts.size
        case line.parts[pos].name
        when :LBRACE, :COLON
          depth += 1
        when :RBRACE
          depth -= 1
        when :SEMIC
          depth -= 1
        when :FARROW
          next if depth != 1
  
          parampos = pos - 1
          parampos -= 1 while [:BLANK, :RETURN].include?(line.parts[parampos].name)
          next unless line.parts[parampos].name == :NAME && line.parts[parampos].value == param_name
          start = parampos - 1
          start -= 1 while [:BLANK, :RETURN].include?(line.parts[start].name)
          start += 1
  
          loop do
            pos += 1
            break if depth < 0 || pos >= line.parts.size
            case line.parts[pos].name
            when :LBRACE
              depth += 1
            when :COMMA, :SEMIC, :RBRACE
              depth -= 1 if line.parts[pos].name == :RBRACE
              next if depth > 1
              pos += 1 if line.parts[pos].name == :RBRACE && depth == 1
              pos += 1 while pos < line.parts.size && ![:COMMA, :SEMIC, :RBRACE].include?(line.parts[pos].name)
              break
            end
          end

          return nil if pos >= line.parts.size
          pos -= 1 unless line.parts[pos].name == :COMMA
          pos -= 1 while [:BLANK, :RETURN].include?(line.parts[pos].name)
  
          return [start, pos]
        end
      end
      nil
    end
  end
end # module

workersglob = File.join(File.dirname(__FILE__), "workers", "*.rb")
Dir[workersglob].each {|worker| require worker }
