require "language/node"

class VueCli < Formula
  desc "Standard Tooling for Vue.js Development"
  homepage "https://cli.vuejs.org/"
  url "https://registry.npmjs.org/@vue/cli/-/cli-5.0.6.tgz"
  sha256 "931b352f6aa7fae2158a01240312fe391a3053f7dfaa9c686b2fb370aeee4c50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ca291e3c206cf68000d22ca7f9af234801aa691fe2d83ef4d44ef35d15b90a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ca291e3c206cf68000d22ca7f9af234801aa691fe2d83ef4d44ef35d15b90a5"
    sha256 cellar: :any_skip_relocation, monterey:       "f1e1b48f1a37ca7ce72496628693f08a0873540d3751c72ddcc4f3ae48b2a103"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1e1b48f1a37ca7ce72496628693f08a0873540d3751c72ddcc4f3ae48b2a103"
    sha256 cellar: :any_skip_relocation, catalina:       "f1e1b48f1a37ca7ce72496628693f08a0873540d3751c72ddcc4f3ae48b2a103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "344261851a33141f8803567f998803dfd7c4e72668dba43675de4776fae34889"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/@vue/cli/node_modules/node-notifier/vendor"
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
    (testpath/".vuerc").write <<~EOS
      {
        "useTaobaoRegistry": false,
        "packageManager": "yarn"
      }
    EOS

    assert_match "yarn", shell_output(bin/"vue config")
    assert_match "npm", shell_output(bin/"vue info")
  end
end
