require "language/node"

class VueCli < Formula
  desc "Standard Tooling for Vue.js Development"
  homepage "https://cli.vuejs.org/"
  url "https://registry.npmjs.org/@vue/cli/-/cli-5.0.3.tgz"
  sha256 "4eab08d5a8f379367afa74e61463dfc5f734630d5533271807d9cd24c0d5a8cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9522eb2fa4776aebf9d12fac856b2a1322a1cb6eb82f95e0f1ead581885ccf99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9522eb2fa4776aebf9d12fac856b2a1322a1cb6eb82f95e0f1ead581885ccf99"
    sha256 cellar: :any_skip_relocation, monterey:       "418c3ad13b479065e09518caff79f7dff6eed426f4bbdccca41895498c9fe7df"
    sha256 cellar: :any_skip_relocation, big_sur:        "418c3ad13b479065e09518caff79f7dff6eed426f4bbdccca41895498c9fe7df"
    sha256 cellar: :any_skip_relocation, catalina:       "418c3ad13b479065e09518caff79f7dff6eed426f4bbdccca41895498c9fe7df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6b49ffdd152968b2cebff8ae033120cb6c00ed6d4f5e3b8ebb1d3d00cba7a6c"
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
