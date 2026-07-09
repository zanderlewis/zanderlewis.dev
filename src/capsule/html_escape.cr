module Capsule
  module HtmlEscape
    def self.escape(text : String) : String
      text
        .gsub("&", "&amp;")
        .gsub("<", "&lt;")
        .gsub(">", "&gt;")
        .gsub("\"", "&quot;")
    end
  end
end
