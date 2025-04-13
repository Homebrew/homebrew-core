class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.7.1.tgz"
  sha256 "c92fe8ae8756f86bc893ec3dff6d85653de242eb671af0430807064db79d9cd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd5d2aa5e74f6c90fab27c5fb63afb21c59cae849a65ed257848c689bd5f043e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aa6c820accaa95b19c29fc1512ee089f49c630a0b8a11ca84562870a332d4a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0178437b507dcbd66fcee1dcd2d74ee18978674c727dd0b6df3aa20d700fda7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6940e85bf990b6acdea29bf09b494353029c21b4d61643ec8c38020ffac079b2"
    sha256 cellar: :any_skip_relocation, ventura:       "f04f8e8ff0fd5e33596507b7ff9a6d0c27e66c35252c98fd5ec7df0fea6c798d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "076f6542dcfd9cffe3a41f7d5a104e93b1e7740cfc43c494ec812d777a15e875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87f49e5d71d234798903200f21b2801ca3eb962b86ac3cf193fed8a444cb3beb"
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
