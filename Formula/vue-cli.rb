require "language/node"

class VueCli < Formula
  desc "Standard Tooling for Vue.js Development"
  homepage "https://cli.vuejs.org/"
  url "https://registry.npmjs.org/@vue/cli/-/cli-4.5.13.tgz"
  sha256 "540e6931c55f4b73487a5b714fb57a2e697c40aa6796aac7e85a8ec98cdbdd53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "19ee315c8dce6ad5a7d4a730791c863b805e064280fe17bfb637647619c78640"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd9ce4bc894223d6cb62993a235cbc3f20a30126c0bce5912de6e457fdb69e84"
    sha256 cellar: :any_skip_relocation, catalina:      "bd9ce4bc894223d6cb62993a235cbc3f20a30126c0bce5912de6e457fdb69e84"
    sha256 cellar: :any_skip_relocation, mojave:        "bd9ce4bc894223d6cb62993a235cbc3f20a30126c0bce5912de6e457fdb69e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2aadb882a707a6239567c5207053752e1e7e1f8b2bca1cbb3de3c3274489bae"
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
