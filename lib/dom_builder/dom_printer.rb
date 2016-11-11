require 'dom_builder/tag_parser'
require 'dom_builder/dom_parser'

class DOMPrinter
  def initialize(yaml)
    self.load(yaml)
  end

  def self.load(yaml)
    deserialized = YAML::load(yaml)
    output(deserialized)
  end

  def self.output(html)
    puts html[:doctype] if html[:doctype]
    print_tag(html[:dom])
  end

  def self.print_tag(tag, depth = 0)

    tab = "  "*depth

    print "#{tab}<#{tag.type}"
    tag.attributes.each do |key, val|
      val = val.join(" ") if val.is_a?(Array)
      print " #{key}='#{val}'"
    end
    tag.data.each {|key, val| print " data-#{key}='#{val}'"}
    puts ">"

    tag.content.each do |item|
      if item.is_a?(TagParser)
        print_tag(item, depth+1)
      else
        puts "#{tab}  #{item}"
      end
    end

    puts "#{tab}</#{tag.type}>"

  end
end