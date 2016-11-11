require 'yaml'
require 'dom_builder/node'
require 'dom_builder/dom_parser'

class TreeSearcher

  attr_reader :tree, :nodes

  def initialize(tree)
    doc = YAML::load(tree)
    @doctype = doc[:doctype]
    @nodes = crawl(doc[:dom])
  end

  def crawl(node, parent = nil, nodes = [])
    node = Node.new(node, parent) unless node.is_a?(Node)
    nodes << node
    node.tag.content.each do |item|
      if item.is_a?(TagParser)
        crawl(item, node, nodes)
      end
    end
    nodes
  end

  def search_by(sym, val, partial = false, search_list = @nodes)
    matches = []
    search_list.each do |node|
      if sym != :class
        if partial
          matches << node if node.tag.attributes[sym] =~ /#{val}/
        else
          matches << node if node.tag.attributes[sym] == val
        end
      else
        next unless node.tag.attributes[:classes]
        if partial
          matches << node if node.tag.attributes[:classes].any?{|item| item =~ /#{val}/ }
        else
          matches << node if node.tag.attributes[:classes].include?(val)
        end
      end
    end
    matches
  end

  def search_descendents(node, sym, val, partial = false)
    nodes = crawl(node)
    nodes.shift
    search_by(sym, val, partial, nodes)
  end

  def search_ancestors(node, sym, val, partial = false)
    search_by(sym, val, partial, get_parents(node))
  end

  private

    def get_parents(node, parents = [])
      return parents unless node.parent
      parents << node.parent
      parents = get_parents(node.parent, parents)
    end

end