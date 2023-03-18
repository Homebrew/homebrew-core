require "language/node"

class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.3.1.tgz"
  sha256 "b0de352c455bf566c5b7fd4d97fa122c85c5d955f97f7bcc4580f4ac8cfcb724"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a13276ce2bc90546ab3102ea430fe330509172abd06339e15da58a4e5004e4fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "696a284a01e5db675c0f550ea8e832deb141e80972094f74ecb4b13dfd7bec38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "218262d67b7a610a463bfd74042ff56a4e2277f9fd6bfb360f93db3c26a4b92a"
    sha256 cellar: :any_skip_relocation, ventura:        "08d47687f54a446a29ef8fbcd70000f92dc5f0beacdbdeb142dbf3e54204c833"
    sha256 cellar: :any_skip_relocation, monterey:       "3e047f20b00abef4824c495b3671952983f1aff29d7edba0ac288e0dd3bcf3ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5ba6145ef583761212bbce73e5d805a8bd3a77f1babf8b9410f01a05f07ab72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "899f267d471a66bdaf069e3bde3a5efb0ee1a5cb5a1ff7bf50a3dd5afbc793c2"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/sql-language-server/node_modules/node-notifier/vendor"
    node_notifier_vendor_dir.rmtree # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/sql-language-server/node_modules/fsevents/fsevents.node"
  end

  test do
    require "open3"

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

    Open3.popen3("#{bin}/sql-language-server", "up", "--method", "stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
