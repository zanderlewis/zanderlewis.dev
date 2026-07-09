module Capsule
  module Capsules
    module Block
      OPEN_PATTERN = /^:::\s*(\w+)(?:\s*\{([^}]*)\})?\s*$/
      CLOSE_PATTERN = /^:::\s*$/

      def self.extract(text : String, markdown : String -> String) : Tuple(String, Array(String))
        lines = text.lines
        output = [] of String
        fragments = [] of String
        i = 0

        while i < lines.size
          line = lines[i]
          if (match = line.match(OPEN_PATTERN))
            kind = match[1].to_s.downcase
            attrs_raw = match[2]?.try(&.to_s) || ""
            attrs = Attributes.parse(attrs_raw)
            i += 1
            body_lines = [] of String
            while i < lines.size
              current = lines[i]
              if current.match(CLOSE_PATTERN)
                i += 1
                break
              end
              body_lines << current
              i += 1
            end
            body = body_lines.join("\n")
            fragments << render(kind, attrs, body, markdown)
            output << "<!--CAPSULE_BLOCK_#{fragments.size - 1}-->"
            next
          end

          output << line
          i += 1
        end

        {output.join("\n"), fragments}
      end

      private def self.render(kind : String, attrs : Hash(String, String), body : String, markdown : String -> String) : String
        inner = markdown.call(body)

        case kind
        when "project"
          render_project(attrs, inner)
        when "timeline"
          render_timeline(attrs, inner)
        when "note", "warning", "tip"
          render_admonition(kind, inner)
        else
          %(<div class="capsule-unknown" data-type="#{HtmlEscape.escape(kind)}">#{inner}</div>)
        end
      end

      private def self.render_project(attrs : Hash(String, String), body : String) : String
        name = attrs["name"]? || "Project"
        status = attrs["status"]? || "active"
        status_class = %( status-#{HtmlEscape.escape(status)})
        links = build_project_links(attrs)

        %(<div class="project-capsule#{status_class}">
  <div class="capsule-meta">
    <h3>#{HtmlEscape.escape(name)}</h3>
    <div class="capsule-links">#{links}</div>
  </div>
  <div class="capsule-body">
    #{body}
  </div>
</div>)
      end

      private def self.build_project_links(attrs : Hash(String, String)) : String
        links = [] of String

        if github = attrs["github"]?
          url = github.starts_with?("http") ? github : "https://github.com/#{github}"
          links << repo_link(url, "GitHub")
        end

        if codeberg = attrs["codeberg"]?
          url = codeberg.starts_with?("http") ? codeberg : "https://codeberg.org/#{codeberg}"
          links << repo_link(url, "Codeberg")
        end

        if demo = attrs["url"]?
          links << repo_link(demo, "Live")
        end

        links.join("\n      ")
      end

      private def self.repo_link(url : String, label : String) : String
        %(<a href="#{HtmlEscape.escape(url)}" class="repo-link">#{HtmlEscape.escape(label)}</a>)
      end

      private def self.render_timeline(attrs : Hash(String, String), body : String) : String
        company = attrs["company"]? || ""
        role = attrs["role"]? || ""
        date = attrs["date"]? || ""

        %(<div class="timeline-capsule">
  <div class="timeline-header">
    <span class="timeline-date">#{HtmlEscape.escape(date)}</span>
    <span class="timeline-company">#{HtmlEscape.escape(company)}</span>
  </div>
  <div class="timeline-body">
    <h4>#{HtmlEscape.escape(role)}</h4>
    #{body}
  </div>
</div>)
      end

      private def self.render_admonition(kind : String, body : String) : String
        label = kind.upcase
        %(<div class="admonition-capsule type-#{HtmlEscape.escape(kind)}">
  <div class="admonition-label">#{label}</div>
  <div class="admonition-content">
    #{body}
  </div>
</div>)
      end
    end
  end
end
