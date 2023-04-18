require "language/node"

class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.5.0.tgz"
  sha256 "b35f941fc79b0eebf8832885c6156a85ddded0f1563d468b21e24f22dde609ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3458875f28e55e8c1b888a918638021207464cdbc1606bf48053da7c692af6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e78af300dcf4ff031adde868eff802fcf8f56c535b5d75d6cf2f25f5603d83bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0a19820ebda528fecdc9a542dac3275e67bf324910ec5cff4a52f72f96781b2"
    sha256 cellar: :any_skip_relocation, ventura:        "47ecd1e5d54117732da90f0ea038be5b58df7b14324890aeea5def335033526b"
    sha256 cellar: :any_skip_relocation, monterey:       "c923fb48a611b1f8c550b8dfea2317a79a569304fb8d8b857e5e884f3af926f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5b19cf83e26fa0bb1d5e5895ec1943d0f0f2cbf92ea6f822fe77a23d81f53ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6521d6704bfdc9f054b2e5c992c98b11ec1013c86f88c16d1c048418041176d6"
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
