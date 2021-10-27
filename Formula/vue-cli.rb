require "language/node"

class VueCli < Formula
  desc "Standard Tooling for Vue.js Development"
  homepage "https://cli.vuejs.org/"
  url "https://registry.npmjs.org/@vue/cli/-/cli-4.5.14.tgz"
  sha256 "9a3ff95a13f46c5dbdfedb6f59498c78de6ab533f9ae8634a00ed0d26d386fcc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d132b2c409bd324996c930cfd50b12ccea390e9e70e685c947a923ba69294ba4"
    sha256 cellar: :any_skip_relocation, big_sur:       "1f33734e64b6ac57409b66f7f738b6115a97b74073fce1283ff88b5ffec932e7"
    sha256 cellar: :any_skip_relocation, catalina:      "1f33734e64b6ac57409b66f7f738b6115a97b74073fce1283ff88b5ffec932e7"
    sha256 cellar: :any_skip_relocation, mojave:        "1f33734e64b6ac57409b66f7f738b6115a97b74073fce1283ff88b5ffec932e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c3d44ef0d1de3198e5fe0c80667d74ec6989413d2664c5cbf016eb6248c68ea"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove vendored pre-built binary `term-size`
    term_size_vendor_dir = libexec/"lib/node_modules/@vue/cli/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/@vue/cli/node_modules/node-notifier/vendor"
    node_notifier_vendor_dir.rmtree # remove vendored pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir

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
