class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "181ca5a798aa073048ab9bc171ba4107f35ec5a4ac9abacd29bdf54e935a9913"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4cd79c3bee20da370e79823cb5ded548322dda9db44d5ae570a86db9144e3a97"
    sha256 cellar: :any, arm64_tahoe:       "5d14ff4f38793ff2ecc27bc16437c406375c9425db70d512748f9a3d03d80618"
    sha256 cellar: :any, arm64_sequoia:     "76a0b369f647e9f3d83924dc2a5b5a459c8cf4ac509eec1e69f7b82ec91259b4"
    sha256 cellar: :any, arm64_linux:       "5a2b5695daeb1c8eec47e67848b29fb208ae5cca7591cec0f5adefeae12e5960"
    sha256 cellar: :any, x86_64_linux:      "70134a42a55332f8477fa4e1f302df59351019a34303c300b18c9aaebe6c21e5"
  end

  depends_on "openssl@4"
  depends_on "ruby"

  deny_network_access!

  def fetch
    ENV["BUNDLE_PATH"] = ".bundle"

    system "bundle", "cache", "--no-install"
  end

  def install
    ENV["GEM_HOME"] = libexec

    system "bundle", "install", "--local"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"

    bin.install libexec/"bin/rails-mcp-server"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/".config/rails-mcp/projects.yml").write <<~YAML
      test: #{testpath}
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
