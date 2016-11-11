require_relative 'parse_tag'

class TagDataR

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

  def build_dom(queue, idx = 0)
    content, dom = [], nil

    until !queue || queue.length == 0

      item = queue.shift

      if item =~ REGEX[:open]

        dom = ParseTag.new(item)
        dom.content, queue = build_dom(queue)
        content << dom

      elsif item =~ REGEX[:closing]

        return content, queue

      else

        content  << item

      end
    end

    dom

  end
end

