module Puppet::Cleaner
  class MultilineComments < Worker
    def part_names
      [:MLCOMMENT]
    end
  
    def operate(line)
      pos = line.position
      comments = line.current.value.split("\n")
      line.remove(pos)
      comments.map! do |comment|
        [Part.create([:COMMENT, {:value => comment}]),
         Part.create([:RETURN, {:value => "\n"}])]
      end
      line.insert(pos, comments.flatten)
    end
  end
end
