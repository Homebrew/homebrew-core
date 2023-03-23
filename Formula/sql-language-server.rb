require "language/node"

class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.4.0.tgz"
  sha256 "8c6fd882ea05dee95e18aa737180a21a9a02d683b8ec26c0b5cd83e208c9b0af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "178d45fa97410f3a031787885552ba57db26812be7b7609e937c7b90c412239a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f200e7971b71abf7eaca742eb250ceb59e041c91b31b28a38b2033375af6732d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8648ca214dd4e88fff14566b3c23a3726747400bb33bdb1f96fdd4131c04c32"
    sha256 cellar: :any_skip_relocation, ventura:        "01aae01ed0c626b87b93d90dd7bd5d0cbe3cd7d319689536cf7d095b8c44166a"
    sha256 cellar: :any_skip_relocation, monterey:       "81dbb2cbf7c268b08fd71ad5ee0c4da3c0dbcc12fd06df849527e37dd261ecbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "deb8fcfe3839fd8eb610de5e770da74ac77f54450ba22475b643d052015a5ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "756714188d04bf0d5ce602111866aa0d2f8afb0afd08d368b9611234df986562"
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
