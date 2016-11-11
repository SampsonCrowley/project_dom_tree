require 'dom_builder/node'
require 'dom_builder/dom_parser'
require 'dom_builder/tree_searcher'
require 'dom_builder/dom_stats'

describe DOMStats do

  let(:stats) { DOMStats.new(DOMParser::serialize("short_test.html"))}
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

    it "initializes a YAML string" do
      expect{ stats }.not_to raise_error
    end

  end

  describe "#render" do

    it "prints all stats for the document tree" do
      expect{ stats.render }.not_to raise_error
      expect(stats.render).to eq(stats_hash)
      expect(stats.render(stats.searcher.nodes[2])).to eq(child_stats_hash)
    end

  end

end