require_relative 'parse_tag'

class TagData

  REGEX = {tags: /<[^>]+>/, open:/<([^\/].*?)>/, closing: /<\/(.*?)>/}

  def initialize(html)
    tags = html.scan(REGEX[:tags])
    content = html.split(REGEX[:tags])
    queue = []
    until tags.empty?
      queue << content.shift << tags.shift
    end
    queue[0] = nil
    queue.shift
    build_dom(queue)
  end

  def build_dom(queue, parent = nil)
    idx = 0
    content = []
    stack = []
    while idx < queue.length
      item = queue[idx]
      if item =~ REGEX[:open]
        stack << ParseTag.new(item)
      elsif item =~ REGEX[:closing]
        if stack.length > 1
          stack[-2].content << stack.pop
        else
          return stack[0]
        end
      else
        stack[-1].content << item
      end
      idx += 1
    end
  end
end


time = Time.now
1000000.times do
TagData.new("<div> div text before <p> p text </p> <div> more div text </div> div text after</div>")
end
p Time.now - time
