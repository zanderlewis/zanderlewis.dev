require "yaml"
require "file_utils"

require "./parser"

module Capsule
  class Config
    getter title : String
    getter description : String
    getter author : String
    getter base_url : String
    getter output : String
    getter content_dir : String
    getter location : String
    getter tagline : String
    getter github : String
    getter codeberg : String
    getter website : String

    def initialize(
      @title : String = "Capsule",
      @description : String = "",
      @author : String = "",
      @base_url : String = "/",
      @output : String = "public",
      @content_dir : String = "content",
      @location : String = "",
      @tagline : String = "",
      @github : String = "",
      @codeberg : String = "",
      @website : String = "",
    )
    end

    def self.load(path : String = "capsule.yml") : Config
      return Config.new unless File.exists?(path)

      data = YAML.parse(File.read(path))
      Config.new(
        title: data["title"]?.try(&.as_s) || "Capsule",
        description: data["description"]?.try(&.as_s) || "",
        author: data["author"]?.try(&.as_s) || "",
        base_url: data["base_url"]?.try(&.as_s) || "/",
        output: data["output"]?.try(&.as_s) || "public",
        content_dir: data["content_dir"]?.try(&.as_s) || "content",
        location: data["location"]?.try(&.as_s) || "",
        tagline: data["tagline"]?.try(&.as_s) || "",
        github: data["github"]?.try(&.as_s) || "",
        codeberg: data["codeberg"]?.try(&.as_s) || "",
        website: data["website"]?.try(&.as_s) || "",
      )
    end
  end

  struct Page
    getter path : String
    getter url : String
    getter title : String
    getter meta : Hash(String, YAML::Any)
    getter html : String
    getter date : String?

    def initialize(@path, @url, @title, @meta, @html, @date = nil)
    end
  end

  class Site
    getter config : Config
    getter pages : Array(Page)

    UNSAFE_OUTPUT_DIRS = {".", "./", "..", "/", ""}

    def initialize(@config : Config)
      @pages = [] of Page
    end

    def build(root : String = ".")
      content_path = File.join(root, config.content_dir)
      output_path = resolve_output_path(root)

      FileUtils.rm_rf(output_path)
      Dir.mkdir_p(output_path)

      collect_pages(content_path, root)
      @pages.sort_by! { |p| p.date || "" }.reverse!

      @pages.each do |page|
        write_page(page, output_path, root)
      end

      copy_assets(root, output_path)
      puts "Built #{@pages.size} page(s) → #{config.output}/"
    end

    private def resolve_output_path(root : String) : String
      output = config.output.strip
      normalized = output.gsub(%r{/\z}, "")

      if UNSAFE_OUTPUT_DIRS.includes?(normalized)
        raise ArgumentError.new(
          "Unsafe output path #{output.inspect}. Use a subdirectory like \"public\" — never \".\" or \"./\"."
        )
      end

      resolved = File.expand_path(output, root)
      root_abs = File.expand_path(root)

      if resolved == root_abs
        raise ArgumentError.new(
          "Output path resolves to the project root. Set output to a subdirectory like \"public\" in capsule.yml."
        )
      end

      resolved
    end

    private def collect_pages(content_path : String, root : String)
      return unless Dir.exists?(content_path)

      Dir.glob(File.join(content_path, "**", "*.cml")).each do |filepath|
        next unless File.extname(filepath) == ".cml"

        meta, html = Parser.parse_file(filepath)
        rel = filepath.sub(content_path + "/", "").sub(/\.cml$/, "")
        url = rel == "index" ? "/" : "/#{rel}/"
        title = meta["title"]?.try(&.as_s) || humanize(rel)
        date = meta["date"]?.try { |d| d.as_s? || d.to_s }

        @pages << Page.new(filepath, url, title, meta, html, date)
      end
    end

    private def write_page(page : Page, output_path : String, root : String)
      out_rel = page.url == "/" ? "index.html" : "#{page.url.strip("/")}/index.html"
      out_file = File.join(output_path, out_rel)
      Dir.mkdir_p(File.dirname(out_file))

      layout = File.read(File.join(root, "templates", "layout.html"))
      nav = build_nav(page.url)

      rendered = layout
        .gsub("{{title}}", escape(page.title))
        .gsub("{{site_title}}", escape(config.title))
        .gsub("{{description}}", escape(config.description))
        .gsub("{{author}}", escape(config.author))
        .gsub("{{tagline}}", escape(config.tagline))
        .gsub("{{location}}", escape(config.location))
        .gsub("{{github}}", escape(config.github))
        .gsub("{{codeberg}}", escape(config.codeberg))
        .gsub("{{website}}", escape(config.website))
        .gsub("{{content}}", page.html)
        .gsub("{{nav}}", nav)
        .gsub("{{base_url}}", config.base_url)

      File.write(out_file, rendered)
    end

    private def build_nav(current_url : String) : String
      nav_pages = @pages
        .uniq(&.url)
        .sort_by { |p| p.url == "/" ? "" : p.title }

      nav_pages.map do |p|
        label = p.url == "/" ? "Home" : p.title
        active = p.url == current_url ? " nav-link--active" : ""
        %(<a href="#{p.url}" class="nav-link#{active}">#{escape(label)}</a>)
      end.join("\n        ")
    end

    private def copy_assets(root : String, output_path : String)
      assets_src = File.join(root, "assets")
      return unless Dir.exists?(assets_src)

      FileUtils.cp_r(assets_src, File.join(output_path, "assets"))
    end

    private def humanize(slug : String) : String
      slug.split('/').last.gsub(/[-_]/, " ").split.map(&.capitalize).join(" ")
    end

    private def escape(text : String) : String
      HtmlEscape.escape(text)
    end
  end
end
