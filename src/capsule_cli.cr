require "./capsule/site"
require "./capsule/server"

module Capsule
  module CLI
    def self.run(args : Array(String))
      command = args[0]? || "build"
      root = Dir.current

      case command
      when "build"
        config = Config.load(File.join(root, "capsule.yml"))
        Site.new(config).build(root)
      when "serve"
        port = (args[1]? || "3000").to_i
        Server.serve(root, port)
      when "init"
        init_project(root)
      when "help", "-h", "--help"
        print_help
      else
        puts "Unknown command: #{command}"
        print_help
        exit 1
      end
    end

    private def self.init_project(root : String)
      dirs = ["content", "content/blog", "templates", "assets"]
      dirs.each { |d| Dir.mkdir_p(File.join(root, d)) }

      puts "Initialized Capsule project in #{root}"
      puts "Edit content/*.cml, then run: capsule build"
    end

    private def self.print_help
      puts <<-HELP
      Capsule — Crystal Static Site Generator with CML

      Usage:
        capsule build          Build site to public/
        capsule serve [port]   Serve built site (default: 3000)
        capsule init           Scaffold project directories
        capsule help           Show this help

      Configuration: capsule.yml
      Content:        content/**/*.cml
      Output:         public/  (never use "." or "./")
      HELP
    end
  end
end

Capsule::CLI.run(ARGV)
