require "language/node"

class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.7.0.tgz"
  sha256 "c66e8d94863c52c34cab0865be3bac61f152e8029ba32d95778d984c8e0a49b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a63e7d173e1c5354c92882c33f7fe031c2e1edfec6c9538f3b9a36cb4f0444b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99b6e7f27dfbdfa08fc3b7f97c20c1f9b9b95e307e754e0d5b904da5eeff2e9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5753d4c1eebff055fbab64a447ff938b6c6743f73f0cd5fce96e13c526d7e1ac"
    sha256 cellar: :any_skip_relocation, ventura:        "627204ccb373dfa3a9309b9a3a52f71567f2135df4d24cb32d319d09a98d690f"
    sha256 cellar: :any_skip_relocation, monterey:       "3422ab64c3c24fb0c71c861b7111d3b6742435cdc3d4fb95e0db74ff1889bfd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5df0c786a71bef62e093b568ca34aaf098b8c67c0e9fbd0d1f5638895649c2c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44a0a7bce4b1e6b7d5f4907956a0d1384029f3f3effdb7762aee5df3ef6b375b"
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
