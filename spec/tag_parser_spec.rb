require 'tag_parser'

describe ParseTag do

  let(:str_w_attr) { "<p class='foo bar' id='baz' name='fozzie' something='test' data-something='test'>" }
  let(:test_tag) { ParseTag.new(str_w_attr) }

  describe '#new' do

    it 'does not raise an error when a string is passed' do
      expect{test_tag}.not_to raise_error
    end

    it 'grabs a type from the tag string' do
      expect(test_tag.type).to eq('p')
    end

    it "grabs an existing id" do
      expect(test_tag.id).to eq("baz")
    end

    it "grabs existing classes" do
      expect(test_tag.classes).to eq(["foo", "bar"])
    end

    it "grabs an existing name" do
      expect(test_tag.name).to eq("fozzie")
    end

    it "parses any attributes" do
      expect(test_tag.attributes).to eq({classes: ["foo", "bar"], id: "baz", name: "fozzie", something: "test"})
    end

    it "parses any data attributes" do
      expect(test_tag.data).to eq({something: "test"})
    end

  end

end
