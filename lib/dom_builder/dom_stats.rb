require 'dom_builder/node'
require 'dom_builder/tree_searcher'

class DOMStats

  attr_reader :searcher

  def initialize(tree)
    @searcher = TreeSearcher.new(tree)
  end

  def render(node = nil)
    node = node || searcher.nodes[0]
    stats = build_stats(node)
    print_to_screen(stats)
    stats
  end


  private
    def print_to_screen(stats)
      puts "\n\nNode Tree Statistics:"
      puts "\n  - Node Type: #{stats[:type]}"
      puts "\n  - Attributes: "
      stats[:attributes].each do |key, val|
        if key == :classes
          vals = ""
          val.each_with_index do |item, i|
            vals << ", " if i > 0
            vals << "#{item}"
          end
          puts "         - #{key}: #{vals}"
        else
          puts "         - #{key}: #{val}"
        end
      end
      puts "\n  - Descendents: #{stats[:descendents]}"
      if stats[:descendents] > 0
        puts "\n  - Descendent Types:"
        stats[:types].each {|key, val| puts "         - #{key}: #{val}"}
      end
      puts "\n\n"
    end

    def build_stats(node)
    stats = {
              type: node.tag.type,
              types: Hash.new {|h,k| h[k] = 0},
              descendents: 0,
              attributes: node.tag.attributes
            }

    node.tag.content.each do |child|
      if child.is_a?(TagParser)
        stats[:types][(child.type)] += 1
        child_stats = build_stats(Node.new(child))
        child_stats[:types].each do |type, val|
          stats[:types][type] += val
        end

        stats[:descendents] += child_stats[:descendents] + 1
      end
    end

    stats
  end
end