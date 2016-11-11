require 'tag_data' 

describe TagData do 

  let(:test_data) { TagData.new("<div> div text before <p> p text </p> <div> more div text </div> div text after</div>") }

  describe '#new' do 

    it 'does not raise an error when a string is passed' do
      expect{test_data}.not_to raise_error
    end

  end

end
