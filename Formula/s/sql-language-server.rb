class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.7.1.tgz"
  sha256 "c92fe8ae8756f86bc893ec3dff6d85653de242eb671af0430807064db79d9cd6"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "90f006d732780a385cdebbdf4c195f5e66a35f43c976552a95ee8a5f155ccbbf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "90f006d732780a385cdebbdf4c195f5e66a35f43c976552a95ee8a5f155ccbbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90f006d732780a385cdebbdf4c195f5e66a35f43c976552a95ee8a5f155ccbbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c99d2ded8d6c79b2e93fd2ea3d65ce7d2a61d8c248f70dc86db6dfe5f2692193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c99d2ded8d6c79b2e93fd2ea3d65ce7d2a61d8c248f70dc86db6dfe5f2692193"
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
    # FIXME: `vscode-languageserver-protocol` 3.18 `exports` block the deep import in `createServer.js`
    inreplace "package.json", '"vscode-languageserver-protocol": "^3.15.3"',
                              '"vscode-languageserver-protocol": "3.17.5"'
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove vendored pre-built binary `terminal-notifier`
    node_modules = libexec/"lib/node_modules/sql-language-server/node_modules"
    node_notifier_vendor_dir = node_modules/"node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    return unless OS.mac?

    terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
    terminal_notifier_dir.mkpath

    # replace vendored `terminal-notifier` with our own
    terminal_notifier_app = formula_opt_prefix("terminal-notifier")/"terminal-notifier.app"
    ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir

    deuniversalize_machos node_modules/"fsevents/fsevents.node"
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
