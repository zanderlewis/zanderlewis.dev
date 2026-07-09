require "markd"

require "./html_escape"
require "./attributes"
require "./front_matter"
require "./preprocessor"
require "./capsules/code"
require "./capsules/block"

module Capsule
  class Parser
    MARKDOWN_OPTIONS = Markd::Options.new(safe: false)

    def self.parse_file(filepath : String) : Tuple(Hash(String, YAML::Any), String)
      raise ArgumentError.new("Not a CML file: #{filepath}") unless File.extname(filepath) == ".cml"

      parse(File.read(filepath))
    end

    def self.parse(content : String) : Tuple(Hash(String, YAML::Any), String)
      meta, body = FrontMatter.split(content)

      markdown_fn = ->(text : String) {
        process_markdown(text)
      }

      body, code_fragments = Capsules::Code.extract(body)
      body, block_fragments = Capsules::Block.extract(body, markdown_fn)
      body = Preprocessor.process_badges(body)

      html = Markd.to_html(body, MARKDOWN_OPTIONS)
      html = inject_fragments(html, "CAPSULE_CODE", code_fragments)
      html = inject_fragments(html, "CAPSULE_BLOCK", block_fragments)

      {meta, html}
    end

    private def self.process_markdown(text : String) : String
      text = Preprocessor.process_badges(text)
      Markd.to_html(text, MARKDOWN_OPTIONS)
    end

    private def self.inject_fragments(html : String, prefix : String, fragments : Array(String)) : String
      fragments.each_with_index do |fragment, index|
        placeholder = "<!--#{prefix}_#{index}-->"
        wrapped = "\n#{fragment}\n"
        html = html.gsub(placeholder, wrapped)
        html = html.gsub("<p>#{placeholder}</p>", wrapped)
      end
      html
    end
  end
end
