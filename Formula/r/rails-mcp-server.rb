class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "3a9fdb7c03ba728e200780a04c10c058e87d51f81470abfcb97075d64208c11d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "266411d2fa7287beef8bbdfbee49535654e7ffc4770c0cef6a54ef14e9bd3a95"
    sha256 cellar: :any,                 arm64_sequoia: "4daba4aef52ba85e9064cb6c6d9bc608a6ceefe6ee051ca45a56e8a496e377fa"
    sha256 cellar: :any,                 arm64_sonoma:  "364dcefd65d8dcd05a1209a642446d0044513b37a07ee2ebef79aaabcc2678dd"
    sha256 cellar: :any,                 sonoma:        "cf42d056cb4bd01fbd9602b6efedd6ebef494fbe04e134dce65ddba85d5ffe70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17a313c3ec68ad6eafdfe9b874c268b7ade8879a747c470ea879c56faaddd277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "166c6790a41329b48e62b4ebb67639739db9bd54f1f864557eae6c2198e35362"
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
