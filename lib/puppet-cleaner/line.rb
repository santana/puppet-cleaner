require 'puppet-cleaner/parts'

module Puppet::Cleaner
  class Line
    attr :position

    def initialize(parts)
      @parts = parts.map {|part| Part.create(part) }
      @workers = Hash.new {|h, k| h[k] = []}
      @position = 0
    end

    def hire(workers)
      @workers.clear
      workers.each do |worker|
        worker.part_names.each {|part_name| @workers[part_name] << worker }
      end
    end

    def transform!
      start do |part|
        @workers[part.name].each do |worker|
          worker.operate(self)
          if part.object_id != current.object_id
            back!
            break
          end
        end
      end
    end

    def inspect
      @parts.inject("") {|m, part| m += "#{part.name.inspect}\t#{part.value.inspect}\n"}
    end

    def show
      start {|part| context = {:before => prev, :after => self.next}; part.show(context) }
    end

    def start
      reset!
      while !empty?
        yield current
        advance!
      end
    end

    def size
      @parts.size
    end

    def reset!
      @position = 0
    end

    def advance!(n = 1)
      @position += n
    end

    def back!(n = 1)
      @position -= n
    end

    def empty?
      @position >= 0 && @position >= size
    end

    def parts
      @parts
    end

    def current
      @parts[@position]
    end

    def next(n = 1)
      (@position + n) >= size ? NoPart : @parts[@position + n]
    end

    def prev(n = 1)
      (@position - n) < 0 ? NoPart : @parts[@position - n]
    end

    def last?
      @position == (size  - 1)
    end

    def lookup(name, ignore = [])
      position = @position
      while position < size && !(ignore + [name]).include?(@parts[position].name)
        position += 1
      end
      position == size || @parts[position].name != name ? nil : position
    end

    def remove(pos)
      @parts.delete_at(pos)
    end

    def insert(pos, parts)
      @parts.insert(pos, *parts)
    end

    def append(pos, parts)
      @parts.insert(pos + 1, *parts)
    end
  end
end
