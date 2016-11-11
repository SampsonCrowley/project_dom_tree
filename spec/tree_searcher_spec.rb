require 'dom_builder/node'
require 'dom_builder/dom_parser'
require 'dom_builder/tree_searcher'

describe TreeSearcher do

  let(:searcher) { TreeSearcher.new(DOMParser::serialize("short_test.html")) }

  describe '#new' do

    it "excepts a YAML tree" do
      expect{searcher}.not_to raise_error
    end

    it "crawls the dom tree" do
      expect(searcher.nodes.length).to eq(3)
    end

  end

  describe '#search_by' do
    it "seaches by a given attribute" do
      expect(searcher.search_by(:class, "top-div").length).to eq(1)
      expect(searcher.search_by(:class, "all").length).to eq(3)
      expect(searcher.search_by(:id, "inner").length).to eq(1)
      expect(searcher.search_by(:name, "emph").length).to eq(1)
    end

    it "accepts a boolean to match partials" do
      expect(searcher.search_by(:class, "top", true).length).to eq(1)
      expect(searcher.search_by(:class, "-div", true).length).to eq(2)
    end
  end

  describe '#search_descendents' do
    it "seaches children of a node by a given attribute" do
      expect(searcher.search_descendents(searcher.nodes[1], :class, "top-div").length).to eq(0)
      expect(searcher.search_descendents(searcher.nodes[1], :class, "all").length).to eq(1)
    end

    it "accepts a boolean to match partials" do
      expect(searcher.search_descendents(searcher.nodes[0], :id, "in", true).length).to eq(1)
      expect(searcher.search_descendents(searcher.nodes[0], :class, "div", true).length).to eq(1)
    end
  end

  describe '#search_ancestors' do
    it "seaches parents of a node by a given attribute" do
      expect(searcher.search_ancestors(searcher.nodes[1], :class, "top-div").length).to eq(1)
      expect(searcher.search_ancestors(searcher.nodes[1], :class, "inner-div").length).to eq(0)
      expect(searcher.search_ancestors(searcher.nodes[2], :class, "all").length).to eq(2)
      expect(searcher.search_ancestors(searcher.nodes[2], :name, "any").length).to eq(0)
    end

    it "accepts a boolean to match partials" do
      expect(searcher.search_ancestors(searcher.nodes[2], :id, "in", true).length).to eq(1)
      expect(searcher.search_ancestors(searcher.nodes[2], :class, "div", true).length).to eq(2)
    end
  end

end