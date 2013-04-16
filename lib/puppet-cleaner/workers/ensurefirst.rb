module Puppet::Cleaner
  class EnsureFirst < Worker
    def part_names
      [:COLON]
    end
  
    def operate(line)
      pos = line.position + 1
      pos += 1 while [:BLANK, :RETURN, :COMMENT, :MLCOMMENT].include?(line.parts[pos].name)
      return if line.parts[pos].name == :NAME && line.parts[pos].value == 'ensure'
      start, pos  = get_param(line, 'ensure', line.position)
      return if start.nil?
  
      ensure_param = line.parts.slice!(start..pos)
      ensure_param += [Part.create([:COMMA, {:value => ","}])] unless ensure_param[-1].name == :COMMA
  
      pos = start
      if line.parts[pos].name == :SEMIC
        commapos = start - 1
        commapos -= 1 while [:RETURN, :BLANK].include?(line.parts[commapos])
        line.parts.delete_at(commapos)
      end
  
      line.append(line.position, ensure_param)
    end
  end
end
