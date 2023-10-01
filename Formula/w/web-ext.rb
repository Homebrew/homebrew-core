require "language/node"

class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-7.7.0.tgz"
  sha256 "482e9eab19c3df4cd353c20bc099c483bf0587a6120482ea811216cf7a02136a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94f3ea601503d9e184d3406cc83e63ff6d6d2cd2a88db7d150b27fbf695cecb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f3ea7d994c7ad54e723410298c1054efbce799ae51ada353473212a12eba88d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcee44d567bf4cf3f2ed0b72366918286377650f5679242eb3fd8828e5c10660"
    sha256 cellar: :any_skip_relocation, ventura:        "0fa28ef9228b232735d19454481e029c3b806b2c7e8111fd61c0b8751689114e"
    sha256 cellar: :any_skip_relocation, monterey:       "eec58db2156b115a89699df713d469a80085c7cb3b50492c87df59cc1b09e40e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8781576a093945a0c131a0c5580e929615a5196e4754cffd6e1a3bfc80fe94f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2393064ee493ef241ed67ae6a0a1fa7fa95c6b38569839720b0b7a059afaa5cf"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/web-ext/node_modules/node-notifier/vendor"
    node_notifier_vendor_dir.rmtree # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end
  end

  test do
    (testpath/"manifest.json").write <<~EOF
      {
        "manifest_version": 2,
        "name": "minimal web extension",
        "version": "0.0.1"
      }
    EOF
    assert_equal <<~EOF, shell_output("#{bin}/web-ext lint").gsub(/ +$/, "")
      Validation Summary:

      errors          0
      notices         0
      warnings        0

    EOF

    assert_match version.to_s, shell_output("#{bin}/web-ext --version")
  end
end
