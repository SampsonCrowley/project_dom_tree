require 'dom_builder/tag_parser'
require 'yaml'

class DOMParserIterative

  REGEX = {doctype:/<!doctype.*?>/, tags: /<[^>]+>/, open:/<([^\/].*?)>/, closing: /<\/(.*?)>/}

  def self.serialize(input)

    html = input_type(input)

    #destructive slice off doctype if exists
    doctype = html.scan(REGEX[:doctype])
    html.slice!(doctype[0]) if doctype[0]

    #build the hash and serialize to YAML
    {
      doctype: doctype[0],
      dom: build_dom(
             # build queue to pass to build_dom
             build_queue(
               # pass tags
               html.scan(REGEX[:tags]),
               # pass content
               html.split(REGEX[:tags])
             )
           )
    }.to_yaml

  end

  private_class_method def self.build_dom(queue)

    idx = 0
    content = []
    stack = []

    while idx < queue.length

      item = queue[idx]

      if item =~ REGEX[:open]
        stack << TagParser.new(item)
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

  private_class_method def self.build_queue(tags, content)

    queue = []
    until tags.empty?
      queue << content.shift.strip << tags.shift
    end
    queue - [""]

  end

  private_class_method def self.input_type(html)

    return File.read(html) if File.exist?(html)
    html

  end

end
