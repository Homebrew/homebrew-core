require "language/node"

class VueCli < Formula
  desc "Standard Tooling for Vue.js Development"
  homepage "https://cli.vuejs.org/"
  url "https://registry.npmjs.org/@vue/cli/-/cli-5.0.4.tgz"
  sha256 "07aba062833f861b86b83e04a70633e8f2f05e56b1db0105477fdc9363a15d4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6c5e203ec126aa6b5d95623a825cb25d0796e4273a2f6e1dc70a7d8754c478a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6c5e203ec126aa6b5d95623a825cb25d0796e4273a2f6e1dc70a7d8754c478a"
    sha256 cellar: :any_skip_relocation, monterey:       "67d68f35121095ee55c66ea352b44fe27b2c38d6283014b6a109b891227adf6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "67d68f35121095ee55c66ea352b44fe27b2c38d6283014b6a109b891227adf6c"
    sha256 cellar: :any_skip_relocation, catalina:       "67d68f35121095ee55c66ea352b44fe27b2c38d6283014b6a109b891227adf6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af33e17fd1fdbd0d55317548c89fe8ce6302476c1c61b83b8c5928affd44af6c"
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
