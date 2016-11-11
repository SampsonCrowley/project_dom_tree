require 'dom_builder/dom_parser'

describe DOMParser do

  let(:parser) { DOMParser::serialize("<div> div text before <p> p text </p> <div> more div text </div> div text after</div>") }
  let(:parser_w_doctype) { DOMParser::serialize("<!doctype html><div> div text before <p> p text </p> <div> more div text </div> div text after</div>") }

  describe '.serialize' do

    it 'does not raise an error when a string is passed' do
      expect{ parser }.not_to raise_error
    end

    it 'does not raise an error when a file is passed' do
      expect{ DOMParser::serialize("short_test.html") }.not_to raise_error
    end

    it "creates a yaml hash from the html string" do
      expect{ YAML::load(parser) }.not_to raise_error
      expect(YAML::load(parser)).to be_a(Hash)
    end

    it "doctype header should be nil if none exists" do
      expect(YAML::load(parser)[:doctype]).to be_nil
    end

    it "adds a doctype header if one exists" do
      expect(YAML::load(parser_w_doctype)[:doctype]).to eq("<!doctype html>")
    end

    it "creates a dom tree of nested TagParser objects" do
      dom = YAML::load(parser)[:dom]
      expect(dom).to be_a(TagParser)
      expect(dom.type).to eq("div")
      expect(dom.content[0]).to eq("div text before")
      expect(dom.content[1]).to be_a(TagParser)
    end

    it "doesn't quit early because of nested dom objects of the same type" do
      dom = YAML::load(parser)[:dom]
      expect(dom.content[-1]).to eq("div text after")
    end

  end

end
