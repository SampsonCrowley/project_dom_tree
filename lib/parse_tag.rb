ParseTag = Struct.new(:type, :attributes) do
  REGEX = {type: /<(.*?)(\s|>)/}
  def initialize(str)
    set_type(str.match(REGEX[:type])[1])
  end
  def set_type(str)
    send(:type=, str)
  end
end
