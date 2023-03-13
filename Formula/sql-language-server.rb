require "language/node"

class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.3.0.tgz"
  sha256 "c979bf37850ba2cb139892e30b0d249df3640dbaab3b4a567c8af967fbe9837a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56138b096802d7d020dce98f4d87f77983bef8273353c9c872f99e8b6498a4b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0959abbbd324585b084e7b61c9f527e0889f70e44a891b2fa6335f0dd620709"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "138290948146b2c6a109bcca8068db1657f7c6787ae0297e088219bcf3fcb395"
    sha256 cellar: :any_skip_relocation, ventura:        "404b3322306ba145aeff8461da9ed91d220728f0d60115151b63b38c25cb4106"
    sha256 cellar: :any_skip_relocation, monterey:       "e3bb726af367c4448479b85811aade197335c7034220c7e3f122806aa07edbca"
    sha256 cellar: :any_skip_relocation, big_sur:        "718d52ef6a3f21c080a4c2ae6254eb0546aec9ed3d071e0261b5b286f2ea32a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f67599530f537b09ef125c3929125c88b63e9c77a5892f660fcce677ecb4c94"
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
