require "language/node"

class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.5.1.tgz"
  sha256 "c0424d11bba8f3842d3ddc731385e54cbab3b910d78113f709a109b92476ec88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7de6942466febb0bee5f52c3603822eaa3f37e3684955e63a886feafaffdb51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4d54951974e9b65b9cdb7c2d65bd38de864b34a2f3f3b5f56c1460baabe7bcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebe68c14cf5bca96dcb483273e4a578e82208edf6361cf2a4954150bc2d1c978"
    sha256 cellar: :any_skip_relocation, ventura:        "9e67311887c4bdfca06c7675b0f0470570996915998900a2f1d254fd51b9908a"
    sha256 cellar: :any_skip_relocation, monterey:       "8c038f156c31beef4a22ed0c6f8f394c78bf0593ff526db2494481c742ac653e"
    sha256 cellar: :any_skip_relocation, big_sur:        "68dd9c4e84854d28fde02f2d15de42fac98d37b87037871da750fede182042cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac48539e66883c4cf8f7a6004b47f0954f52ddcdad040e9656418a229c390388"
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
