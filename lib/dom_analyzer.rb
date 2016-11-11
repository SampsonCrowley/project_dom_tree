$: << File.expand_path("../lib", __FILE__)
require 'dom_builder/node'
require 'dom_builder/tag_parser'
require 'dom_builder/dom_parser'
require 'dom_builder/tree_searcher'
require 'dom_builder/dom_stats'
require 'dom_builder/dom_printer'

class DOMAnalyzer

  attr_reader :tree, :searcher, :stats

  def initialize(html)
    @tree = DOMParser::serialize(html)
    @searcher = TreeSearcher.new(tree)
    @stats = DOMStats.new(tree)
  end

  def analyze(node = nil)
    stats.render(node)
  end

  def search(by, matcher, strict: false, type: nil, node: nil)
    if type
      search_type = "search_#{type}".to_sym
      searcher.public_send(search_type, node, by.to_sym, matcher, !strict)
    else
      searcher.search_by(by.to_sym, matcher, !strict)
    end
  end

  def rebuild
    DOMPrinter::load(tree)
  end

end
