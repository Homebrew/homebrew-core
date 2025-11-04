class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "61b678c95903f671b3915eaabe267cc873eabe0deeb6ca12bcb9b38c55283683"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1280efdc8d30786a99c2c1e41a51980e23ec5294f6484d59d40a589886ce6145"
    sha256 cellar: :any,                 arm64_sequoia: "2503ac25e39bf482d53609ca7f97bc1c8298dc1160536c2deec926f05fc9deab"
    sha256 cellar: :any,                 arm64_sonoma:  "ba7d35ff45257897bea13877bf237318a06924380d90f4713a678667fe800559"
    sha256 cellar: :any,                 sonoma:        "55f25b5a61f55d95ba0cb32147a84c163353461a9b2f969f8f8c2c92166d9b19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1247d44035a235d136ee9c0f68769deb49ac893ea19e0cc2e07c1e2d17136f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "750a710534c0065d6415e12e12a7c167d605ea00047a18f08d0d50b8f0563bb0"
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
