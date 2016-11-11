require 'parse_tag'

class TagData

  REGEX = [/<(\w+)\s*.*?>(.*?)<(\/\2.*?)>$/]

  def initialize(html)
    open_tag = html.scan(REGEX[0])
    p open_tag

  end
end