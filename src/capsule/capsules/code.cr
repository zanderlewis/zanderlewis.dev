module Capsule
  module Capsules
    module Code
      INFO_STRING_PATTERN = /^(\w+)?\s*\{([^}]+)\}/
      FENCE_PATTERN = /^(`{3,}|~{3,})(.*)$/

      def self.extract(text : String) : Tuple(String, Array(String))
        lines = text.lines
        output = [] of String
        fragments = [] of String
        i = 0

        while i < lines.size
          line = lines[i]
          if (match = line.match(FENCE_PATTERN))
            fence = match[1]
            info = match[2].strip
            if (info_match = info.match(INFO_STRING_PATTERN))
              lang = info_match[1]?.try(&.to_s) || ""
              attrs = Attributes.parse(info_match[2].to_s)
              i += 1
              code_lines = [] of String
              while i < lines.size
                current = lines[i]
                if current.starts_with?(fence)
                  i += 1
                  break
                end
                code_lines << current
                i += 1
              end
              fragments << render(lang, attrs, code_lines.join("\n"))
              output << "<!--CAPSULE_CODE_#{fragments.size - 1}-->"
              next
            end
          end

          output << line
          i += 1
        end

        {output.join("\n"), fragments}
      end

      private def self.render(lang : String, attrs : Hash(String, String), code : String) : String
        data_attrs = [] of String
        data_attrs << %(data-lang="#{HtmlEscape.escape(lang)}") unless lang.empty?

        attrs.each do |key, value|
          data_attrs << %(data-#{HtmlEscape.escape(key)}="#{HtmlEscape.escape(value)}")
        end

        title = attrs["title"]?
        lang_class = lang.empty? ? "" : %( class="language-#{HtmlEscape.escape(lang)}")
        data_str = data_attrs.empty? ? "" : " #{data_attrs.join(" ")}"

        header = if title
                   %(
  <div class="capsule-header">
    <span class="capsule-title">#{HtmlEscape.escape(title)}</span>
  </div>)
                 else
                   ""
                 end

        %(<div class="code-capsule"#{data_str}>#{header}
  <pre><code#{lang_class}>#{HtmlEscape.escape(code)}</code></pre>
</div>)
      end
    end
  end
end
