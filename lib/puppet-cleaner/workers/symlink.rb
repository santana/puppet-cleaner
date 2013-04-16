module Puppet::Cleaner
  class Symlink < Worker
    def part_names
      [:NAME]
    end
  
    def operate(line)
      return if line.current.value != 'file'
      pos = line.position + 1
      pos += 1 while pos < line.parts.size && [:BLANK, :RETURN, :COMMENT, :MLCOMMENT].include?(line.parts[pos].name)
      return if pos >= line.parts.size || line.parts[pos].name != :LBRACE
  
      foreach_colon(line) {|colonpos|
        start, pos = get_param(line, 'ensure', colonpos)
        next if start.nil?
        pos -= 1 if line.parts[pos].name == :COMMA
        value = line.parts[pos].value
        next if [:NAME, :STRING].include?(line.parts[pos].name) && %w(present absent file directory link symlink).include?(value)
        next if line.parts[pos].name == :VARIABLE
        ensure_param = [ [:RETURN, {:value => "\n"}], [:NAME, {:value => "ensure"}], [:FARROW, {:value => '=>'}], [:NAME, {:value => 'link'}], [:COMMA, {:value => ","}] ].map {|e| Part.create(e) }
        start += 1 while line.parts[start].name != :NAME
        line.parts[start].value = 'target'
        line.append(colonpos, ensure_param)
      }
    end
  
    def foreach_colon(line)
      pos = line.position
      pos += 1 while pos < line.parts.size && line.parts[pos].name != :LBRACE
      depth = 1
  
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
          yield pos
        end
      end
    end
  end
end
