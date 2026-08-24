class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "181ca5a798aa073048ab9bc171ba4107f35ec5a4ac9abacd29bdf54e935a9913"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e6a330d9f3b0473a4508177486fd63538cf8a4de510a775fb25bbfcf86c6f3ef"
    sha256 cellar: :any, arm64_sequoia: "e9420b62b2c2f5a445d2c0b0c864eedbae43f6fa63ecc5de750def21e87d11c7"
    sha256 cellar: :any, arm64_sonoma:  "20553ae37cdbde2c9b4aceacb914854ef2682fa0ae5281595053a35f9062b81a"
    sha256 cellar: :any, sonoma:        "145694cf9eaa860065d5feab50739bd05b1709d64ac07d5e72746e4b64c3432d"
    sha256 cellar: :any, arm64_linux:   "40d94c86be06dae440594ba24a77d8d1dfe4b261200301c48ded86d11d9de947"
    sha256 cellar: :any, x86_64_linux:  "2f8bb868c239cdc9b30a632caf6798dc30b03f6385bf82c0f1d903bb099e0a10"
  end

  depends_on "openssl@3"
  depends_on "ruby"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
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
