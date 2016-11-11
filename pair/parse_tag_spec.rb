require 'parse_tag'

describe ParseTag do

  let(:test_string) { "<p class='foo bar' id='baz' name='fozzie'>" }
  let(:test_tag) { ParseTag.new(test_string) }

  describe '#new' do

    it 'does not raise an error when a string is passed' do
      expect{test_tag}.not_to raise_error
    end

  end

  describe '#type' do 
w
    it 'grabs a type from the tag string' do 
      expect(test_tag.type).to eq('p')
    end

  end

  d

end