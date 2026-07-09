require "http/server"

require "./site"

module Capsule
  class Server
    def self.serve(root : String, port : Int32 = 3000)
      config = Config.load(File.join(root, "capsule.yml"))
      public_dir = File.expand_path(config.output, root)

      unless Dir.exists?(public_dir)
        puts "No build found. Run `capsule build` first."
        exit 1
      end

      server = HTTP::Server.new do |context|
        path = context.request.path
        path = "/index.html" if path == "/"
        path = path + "/index.html" if !path.ends_with?(".html") && !path.includes?(".")

        file = File.join(public_dir, path.lstrip("/"))
        file = File.join(public_dir, "index.html") if File.directory?(file)

        if File.exists?(file) && !File.directory?(file)
          context.response.content_type = mime_type(file)
          context.response.print File.read(file)
        else
          context.response.status_code = 404
          context.response.print "Not found"
        end
      end

      address = server.bind_tcp("127.0.0.1", port)
      puts "Serving #{config.output}/ at http://#{address}"
      server.listen
    end

    private def self.mime_type(path : String) : String
      case File.extname(path)
      when ".html" then "text/html"
      when ".css"  then "text/css"
      when ".js"   then "application/javascript"
      when ".png"  then "image/png"
      when ".svg"  then "image/svg+xml"
      else              "application/octet-stream"
      end
    end
  end
end
