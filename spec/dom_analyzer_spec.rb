require 'dom_analyzer'

describe DOMAnalyzer do

  let(:analyzer) { DOMAnalyzer.new("short_test.html") }
  let (:stats_hash) { {
                        :type=> "div",
                        :types=> {"div"=>1, "em"=>1},
                        :descendents=>2,
                        :attributes=> {:classes=>["top-div", "all"]}
                      }
                    }
  let (:child_stats_hash) { {
                              :type=>"em",
                              :types=> {},
                              :descendents=>0,
                              :attributes=> {
                                              :name=> "emph",
                                              :classes=>["all"]
                                            }
                            }
                          }

  describe "#new" do

    it "initializes a dom tree" do
      expect{ analyzer }.not_to raise_error
      expect(analyzer.tree).to match(/---\n/)
    end

  end

  describe "#analyze" do
    it "runs an DOMStats analysis on the dom tree" do
      expect(analyzer.analyze).to eq(stats_hash)
    end

    it "can be passed a node to analyze" do
      expect(analyzer.analyze(analyzer.searcher.nodes[2])).to eq(child_stats_hash)
    end
  end

  describe "#search" do
    it "runs a basic attribute search" do
      expect(analyzer.search("class", "top").length).to eq(1)
    end

    it "takes a type of search as an argument" do
      expect(analyzer.search("class", "div", type: "descendents", node: analyzer.searcher.nodes[0]).length).to eq(1)
    end
  end

  describe "#rebuild" do
    it "rebuilds and prints the original html" do
      expect{analyzer.rebuild}.to output(/<!doctype html>/).to_stdout
    end
  end

end