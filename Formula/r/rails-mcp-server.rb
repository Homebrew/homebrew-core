class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "5383902c2efcae00f3d6edd83b14db2cd926844ce01d62cd3fdbce989f5dfb29"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0d02c6aefc3fcff4241e0568e111f739c561e44384fd3c48d793f90fd726d32"
    sha256 cellar: :any,                 arm64_sequoia: "6c97f82fee4a2832a703d07c13558e90ac74b6b6cc2b6d624f3e067cdcb1f09e"
    sha256 cellar: :any,                 arm64_sonoma:  "aea94137aac15e7b5352cc78f1722446644c4db36d4a2e70c164b0c4027ac456"
    sha256 cellar: :any,                 sonoma:        "581825aa12a93c7975ad7d47fbf37eba16b96429d6a5ec89a88a6e24e37059b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cb9d0d0c4a8f45f9652e819192f367f0b1dcdaf2f6e24fa3dd117f89a16db39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "514d61cdca7e9320709ad14a925ec3abdf4d89ea5a88e5cdf92e754d2c937b2c"
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
