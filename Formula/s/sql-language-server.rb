class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.7.1.tgz"
  sha256 "c92fe8ae8756f86bc893ec3dff6d85653de242eb671af0430807064db79d9cd6"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf25118bc997d51a285ac4cbad9ceb6ca1e45ded96ef52c11834a30bf935d5e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1250a7af843e78b2398cdbb217e9625b1f77ecdb695cdc74a173ee377c3f6f25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8191b922c90af4dbe2e3fce69ddf818643bd12c8ced97e454a7c0bd28e6458ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "c24bb22b07a5ba4ce0a6ee838fc5976c7bc50a7d51880f9694ad421fe5faaeb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00eeaa0a119c6512fea47329da49f21c6c04f6d7832eac78d46e0f74f3339d7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b1cdb55cc9429d8f2d34f30bfe5103c93efce6752d4f76cf35053616af74c0"
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
