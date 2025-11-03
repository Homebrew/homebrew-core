class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "61b678c95903f671b3915eaabe267cc873eabe0deeb6ca12bcb9b38c55283683"
  license "MIT"

  depends_on "openssl@3"
  depends_on "ruby"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/rails-mcp-server"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/".config/rails-mcp/projects.yml").write <<~YAML
      projects:
        - name: test
          path: #{testpath}
    YAML

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{"cursor":null}}
    JSON

    output = pipe_output("#{bin}/rails-mcp-server 2>&1", json, 0)
    assert_match "Change the active Rails project to interact with a different codebase", output
  end
end
