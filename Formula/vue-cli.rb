require "language/node"

class VueCli < Formula
  desc "Standard Tooling for Vue.js Development"
  homepage "https://cli.vuejs.org/"
  url "https://registry.npmjs.org/@vue/cli/-/cli-5.0.6.tgz"
  sha256 "931b352f6aa7fae2158a01240312fe391a3053f7dfaa9c686b2fb370aeee4c50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7076253c932a4e51a8ef8ded97a138336a04adbb324472edbcd6b727cfe455d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7076253c932a4e51a8ef8ded97a138336a04adbb324472edbcd6b727cfe455d"
    sha256 cellar: :any_skip_relocation, monterey:       "ae39ac8553a63037ef90aa34045fe51a8361cd1b5357d87a938db529a36ea928"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae39ac8553a63037ef90aa34045fe51a8361cd1b5357d87a938db529a36ea928"
    sha256 cellar: :any_skip_relocation, catalina:       "ae39ac8553a63037ef90aa34045fe51a8361cd1b5357d87a938db529a36ea928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ee742d013a5c838e014f299e8df2cbc4bfe33ecba2d391b7261c499027f7b1e"
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
