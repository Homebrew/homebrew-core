class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "6625c6f80c15b9118c5734d29cb364b4ac955871e584ff42cc9e67ba1c37ffd4"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1d47d3cb8a209856d4fd762eb93c8a4491449e038d0f73796485572f5e424a04"
    sha256 cellar: :any,                 arm64_sonoma:  "c4e66c5a4f1097422214a40e8c4a8172510ed0af63c1cfe6b9428f41ef4f9771"
    sha256 cellar: :any,                 arm64_ventura: "5186a86f59a9c7bfb8dcd822ca1106278529c4e1dc6752ec1db3168c02b95c0f"
    sha256 cellar: :any,                 sonoma:        "411dcf278cbfa1efb9cf8cd4a08737681dde2ba123a4305d21b4b22fb0994a95"
    sha256 cellar: :any,                 ventura:       "310e1231f581fc24f0d1da32a6d4b18d784aa1f8bc8db4c7a6bb0a158d3d3e72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c01257fb8dfbbe3a9e8078e5aae597c2bdbeeaeb5a33fd730dd5675e85065ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1394811197073c75ee1d25f12b91a86041f1e47e049bd5eebc577acaecf6f4f"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files libexec/"bin",
      PATH:     "#{Formula["ruby"].opt_bin}:$PATH",
      GEM_HOME: ENV["GEM_HOME"]
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/ruby-lsp 2>&1", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
