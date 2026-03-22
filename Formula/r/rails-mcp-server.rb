class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "136021dcfe11dcdd4a290e75cf682ea6638bb0bf503b75b9c455903d620d389b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca24397ff487e20748bb4ddd9241f58ac1505b070dac573e1a8d4a34d227e5e3"
    sha256 cellar: :any,                 arm64_sequoia: "7248dcb4b96c195bac662927217ac1abafa84de2a226a466a985c7e9ca6a2310"
    sha256 cellar: :any,                 arm64_sonoma:  "692c4feeaa21a7b0e305b7f8c3fd30a91c9921561d8f9415fb7c372078efd6c4"
    sha256 cellar: :any,                 sonoma:        "6c527031abf145e9e9a88e288619dadda39d8c19926a51c14dcf3fd6c7c2dfaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a54694d01fc553158321e06ec42b3389464f0595a897a9b65d150c3fb1c531c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d338c3be67428afb40f48a17c1d0022f0c9a3e946200b6eff68b9e0da855aaa"
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
