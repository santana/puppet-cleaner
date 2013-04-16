module Puppet::Cleaner
  class SoftTabs < Worker
    def initialize(tabstop = 2)
      @depth = 0
      @tabstop = tabstop
      @resource_tab = {:size => 0, :depth => nil}
    end
  
    def part_names
      [:LBRACE, :RBRACE, :LBRACK, :RBRACK, :LPAREN, :RPAREN, :COLON, :SEMIC, :RETURN]
    end
  
    def operate(line)
      case line.current.name
      when :LBRACE, :LBRACK, :LPAREN
        @depth += 1
      when :RBRACE, :RBRACK, :RPAREN
        @resource_tab[:size] = 0 if line.current.name == :RBRACE && @resource_tab[:depth] == @depth
        @depth -= 1
      when :SEMIC
        @resource_tab[:size] = 0
        @resource_tab[:depth] = nil
      when :COLON
        pos = line.position - 1
        pos -= 1 while pos >= 0 && ![:LBRACE, :RETURN].include?(line.parts[pos].name)
        return if pos < 0 || line.parts[pos].name != :RETURN
        pos = line.position + 1
        pos += 1 while pos < line.parts.size && [:BLANK, :RETURN].include?(line.parts[pos].name)
        return if pos == line.parts.size || line.parts[pos].name == :LBRACE
  
        @resource_tab[:size] = 1
        @resource_tab[:depth] = @depth
      when :RETURN
        return if line.last? || line.next.name == :RETURN
        line.append(line.position, Part.create([:BLANK, {:value => ''}])) if line.next.name != :BLANK
        n = [:RBRACE, :RBRACK, :RPAREN].include?(line.next(2).name) ? 1 : 0
        @resource_tab[:size] = 0 if line.next(2).name == :RBRACE && @resource_tab[:depth] == @depth
        blanks = ' '*@tabstop*(@depth - n + @resource_tab[:size])
        line.next.value = blanks if line.next.value != blanks
      end
    end
  end
end
