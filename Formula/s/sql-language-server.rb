class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.7.0.tgz"
  sha256 "c66e8d94863c52c34cab0865be3bac61f152e8029ba32d95778d984c8e0a49b1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "42ed54577ebee0d08927ecfd9437c5fb34b86550f39ddbb267c8b80d91882321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "236ad1d93cceec6914b58664d6a74deefd1fff1a40e10789c36d150bd7c14686"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ecc11126b7d5fb48941ae187fbcd52853d3e7669c4a28f24f4a6a6d458d5812"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "499c3ccad48b255dbdd91736fb19390c712857f25b7940468a6591db647a6af9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e833963582391c35d8330ef634dd008f0c544df422aa5e420cdb2df5de835bb8"
    sha256 cellar: :any_skip_relocation, ventura:        "8362d4f1dad11b2b775bd243a7068663b229424b5e78f72cc2b493a097d1186b"
    sha256 cellar: :any_skip_relocation, monterey:       "27088ae48dbff0d606e82bea3a4e06376576a631bbf9f8dcbf64fecc7f940211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1be90ee66b585a15ba9e4360e88d97beda26440fc581b28b2dd3907cabf2dea1"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/sql-language-server/node_modules/node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end
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

    Open3.popen3(bin/"sql-language-server", "up", "--method", "stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
