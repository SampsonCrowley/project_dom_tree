ParseTag = Struct.new(:type, :data, :attributes, :content) do

  REGEX = {type: /<(.*?)(\s|>)/,
           attributes: /\s(.*?)=["'](.*?)["']/,
           data: /data-(.*?)$/ }

  def initialize(str)
    set_type(str.match(REGEX[:type])[1])
    self.attributes = {}
    set_attributes(str.scan(REGEX[:attributes]))
  end

  def set_type(str)
    self.type = str
  end

  def set_attributes(match_data)
    match_data.each do |key, value|
      if key == 'class'
        self.attributes[:classes] ||= []
        value = value.split.each { |item| self.attributes[:classes] << item }
      elsif key =~ REGEX[:data]
        self.data ||= {}
        data[key.match(REGEX[:data])[1].to_sym] = value
      else
        attributes[key.to_sym] = value
      end
    end
  end

  def content=(data)
    self.content = data
  end

  def classes
    attributes[:classes]
  end

  def id
    attributes[:id]
  end

  def name
    attributes[:name]
  end

  def title
    attributes[:title]
  end

  def src
    attributes[:src]
  end

end

def parse_tag(tag)
  ParseTag.new(tag)
end

p parse_tag("<p class='foo bar' id='baz' name='fozzie' something='test' data-something='test'>")