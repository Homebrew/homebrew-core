class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.23.16.tar.gz"
  sha256 "1867e575476d8e8d9d4abd2d79cfd9bcb7029762637edb6da10150e38f5491f5"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c57f79c7a18200938bd8a2e39cae5f147aefa73100898e7263180e5bcd8a8d69"
    sha256 cellar: :any,                 arm64_sonoma:  "9a2d7e83e63f48b56b51b22c115338754178877f0752b63d4ca526ed45acc4b9"
    sha256 cellar: :any,                 arm64_ventura: "07db97fe8e10ed970147e464a8a497dc44fedc973a9393f64e8aa06a33d5fa1e"
    sha256 cellar: :any,                 sonoma:        "7e16ad6803c2fc27c79f647a23455c8701ff2c425b14bc12858b692e2cad231c"
    sha256 cellar: :any,                 ventura:       "b2457d2b05353426ea6824984f2c401486f7045e4b83139b01d9690a6f4b1360"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf431727319716a23595a78fd801413b9073836869f1b8974ea225d1dbb2e94f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fed7b44b22c4a2010bfa3cdd2bfe32a77d88a4b36a4a27b7e5935ef0a131c17"
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
