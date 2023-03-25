require "language/node"

class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.4.0.tgz"
  sha256 "8c6fd882ea05dee95e18aa737180a21a9a02d683b8ec26c0b5cd83e208c9b0af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9c4054ef9d423a20bc53194f2e75c31aa703e6055bec885a3f674e67553ae90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6c0e317614f2cc8e26b40f621f3d697233749982de0530e657c3eb910890ce4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6e19f76a90487ea01bb6d4df82e8f80c9519acb5c2ef4c30992ba24e030e19d"
    sha256 cellar: :any_skip_relocation, ventura:        "f1a5103f2c9367a26166eeebcb8404d3647d0cbbf5828e8e8de6f79fdaef1776"
    sha256 cellar: :any_skip_relocation, monterey:       "f6a1e257adfc7cfde80371b1940c948ed8c169d4b4aefb442ef330c3cbba5234"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf3b9760dc616645faec46c468b3221d5921af4dabd31090440b4bf14bb645fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82087f38d2e98935658c6db7bb293f48c52d16311d06dffc285c9df94cdf1559"
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
