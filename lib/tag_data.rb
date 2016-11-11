require_relative 'parse_tag'

class TagData

  REGEX = {tags: /<[^>]+>/, closing: /<\/.*?>/}

  def initialize(html)
    p @tags = html.scan(REGEX[:tags])
    p @content = html.split(REGEX[:tags])[1..-1]
  end

  def build_dom
  end
end

TagData.new("<div> div text before <p> p text </p> <div> more div text </div> div text after</div>")