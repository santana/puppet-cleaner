require 'puppet'

module Puppet::Cleaner
  def self.inspect(filename)
    Puppet[:manifest] = filename
    tc = Puppet::Node::Environment.new(Puppet[:environment]).known_resource_types
    catalog = [:nodes, :hostclasses, :definitions].collect {|meth| tc.send(meth) }
    tc.clear
    catalog
  end
end
