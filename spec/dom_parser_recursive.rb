require 'dom_parser_recursive'

describe DomParserRecursive do

  let(:r_parser) { DomParserRecursive.new("<div> div text before <p> p text </p> <div> more div text </div> div text after</div>") }

  describe '#new' do

    it 'does not raise an error when a string is passed' do
      expect{r_parser}.not_to raise_error
    end

  end

end
