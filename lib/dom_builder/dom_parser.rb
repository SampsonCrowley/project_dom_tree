require 'dom_builder/tag_parser'
require 'yaml'

class DOMParser

  REGEX = {doctype:/<!doctype.*?>/,
           tags: /<[^>]+>/,
           open:/<([^\/].*?)>/,
           closing: /<\/(.*?)>/}

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

  private_class_method def self.build_dom(queue, parent = nil)
    content, dom = [], nil

    until queue.length == 0

      item = queue.shift

      if item =~ REGEX[:open]

        dom = TagParser.new(item)
        dom.content, queue = build_dom(queue, dom)
        content << dom

      elsif item =~ REGEX[:closing]

        return content, queue

      else

        content  << item

      end
    end

    dom

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

