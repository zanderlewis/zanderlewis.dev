module Capsule
  module Attributes
    ATTRIBUTE_PATTERN = /([\w-]+)\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s}]+))/

    def self.parse(raw : String) : Hash(String, String)
      attrs = Hash(String, String).new
      raw.scan(ATTRIBUTE_PATTERN) do |match|
        key = match[1].to_s
        value = match[2]?.try(&.to_s) || match[3]?.try(&.to_s) || match[4]?.try(&.to_s) || ""
        attrs[key] = value
      end
      attrs
    end
  end
end
