require 'dom_builder/dom_printer'

describe DOMPrinter do

  before(:all) do
      # Redirect stderr and stdout
      $stderr = File.new('null.txt', 'w')
      $stdout = File.new('null.txt', 'w')
  end

  after(:all) do
      # Redirect stderr and stdout
      File.delete('null.txt')
  end

  describe '.load' do
    let(:yaml_str) { "---\n:doctype: \"<!doctype html>\"\n:dom: !ruby/struct:TagParser\n  type: div\n  data: {}\n  attributes: {}\n  content:\n  - div text before\n" }

    let(:yaml_dom_only) { "---\n:doctype: \n:dom: !ruby/struct:TagParser\n  type: div\n  data: {}\n  attributes: {}\n  content:\n  - div text before\n" }

    let(:yaml_nested) { "---\n:doctype: \"<!doctype html>\"\n:dom: !ruby/struct:TagParser\n  type: div\n  data: {}\n  attributes: {}\n  content:\n  - div text before\n  - !ruby/struct:TagParser\n    type: p\n    data: {}\n    attributes: {}\n    content:\n    - p text\n  - !ruby/struct:TagParser\n    type: div\n    data: {}\n    attributes: {}\n    content:\n    - more div text\n  - div text after\n" }

    let(:printer) { DOMPrinter::load(yaml_str) }

    it "accepts a yaml string", :allow_output do
      expect{ printer }.not_to raise_error
    end

    it "properly sets a doctype if given" do
      expect{ printer }.to output(/<!doctype html>/).to_stdout
    end

    it "skips doctype if not given" do
      expect{ DOMPrinter::load(yaml_dom_only) }.not_to output(/<!doctype html>/).to_stdout
    end

    it "prints tags and content with indentation" do
      dom_str = "<!doctype html>\n<div>\n  div text before\n</div>\n"
      expect{ printer }.to output(dom_str).to_stdout
    end

    it "prints nested tags" do
      dom_str = "<!doctype html>\n<div>\n  div text before\n  <p>\n    p text\n  </p>\n  <div>\n    more div text\n  </div>\n  div text after\n</div>\n"
      expect{ DOMPrinter::load(yaml_nested) }.to output(dom_str).to_stdout
    end
  end

end
