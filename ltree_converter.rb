require 'pry'
class LtreeConverter
  attr_reader :ltree
  ESCAPE_PATTERN = /--\d+/
  def self.build_hierachy(ltree_list)
    hierarchy = Hash.new { |hash, key| hash[key] = Hash.new(&hash.default_proc) }
    split = ltree_list.map {|item| item.split(".")}
    split.each do |item|
      f = item.reduce(hierarchy) do |h, i|
        h[unescape(i)]
      end
      f[:terminate] = true
    end
    hierarchy
  end

  def initialize(ltree)
    @ltree = ltree
  end

  def self.unescape(ltree)
    escaped_characters = ltree.scan(ESCAPE_PATTERN)
    
    converted = escaped_characters.reduce({}) do |map, item|
      map.merge({item => item.gsub('--', '').to_i.chr})
    end
    ltree
      .gsub("_", " ")
      .gsub(ESCAPE_PATTERN, converted)
  end

  def to_breadcrumbs(connector)
    self.class.unescape(ltree)
      .split(".").join(connector)
  end

  def to_ltree(connector)
    tmp = ltree.gsub(connector, ".")
      .gsub(" ", "_")
    need_escape = tmp.scan(/[^a-zA-Z_.]/)
    converted = need_escape.reduce({}) do |map, item|
      c =  "--#{item.ord}"
      map.merge({item => c})
    end

    tmp.gsub(/[^a-zA-Z_.]/, converted)
  end
end
