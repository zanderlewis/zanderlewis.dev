module Capsule
  module FrontMatter
    def self.split(content : String) : Tuple(Hash(String, YAML::Any), String)
      lines = content.lines
      return {Hash(String, YAML::Any).new, content} unless lines.first?.try(&.strip) == "---"

      body_lines = [] of String
      meta_lines = [] of String
      in_meta = true
      found_close = false

      lines[1..].each do |line|
        if in_meta && line.strip == "---"
          in_meta = false
          found_close = true
          next
        end

        if in_meta
          meta_lines << line
        else
          body_lines << line
        end
      end

      meta = if found_close && !meta_lines.empty?
               YAML.parse(meta_lines.join("\n")).as_h.transform_keys(&.to_s)
             else
               Hash(String, YAML::Any).new
             end

      {meta, body_lines.join("\n")}
    end
  end
end
