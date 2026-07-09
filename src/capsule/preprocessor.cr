module Capsule
  module Preprocessor
    BADGE_PATTERN = /\[\+(\w+)\]/

    def self.process_badges(text : String) : String
      text.gsub(BADGE_PATTERN) do
        tech = $1
        %(<span class="badge badge-#{HtmlEscape.escape(tech)}">#{HtmlEscape.escape(tech)}</span>)
      end
    end
  end
end
