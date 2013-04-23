require 'puppet/parser'
require 'puppet-cleaner/line'
require 'puppet-cleaner/workers/worker'
require 'puppet-cleaner/workers'

class Puppet::Parser::Lexer
  class LexingContext < Hash
    def []=(key, value)
      return if key == :after && value == :BLANK
      super
    end
  end

  TOKENS[:COMMENT].skip = false
  TOKENS[:MLCOMMENT].skip = false
  TOKENS[:RETURN].skip = false
  TOKENS.add_token :BLANK, %r{[ \t\r]+} do |lexer,value|
    value.gsub!(/[\t\r]/,' ')
    [self, value]
  end

  def lexing_context
    @face_lexing_context ||= LexingContext.new.merge(@lexing_context)
  end

  def skip; end
end

module Puppet::Cleaner
  def self.open(filename)
    lexer = Puppet::Parser::Lexer.new
    lexer.file = filename
    tokens = lexer.fullscan
    lexer.clear
    Line.new(tokens[0..-2])
  end
end
