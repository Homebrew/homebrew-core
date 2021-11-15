require "language/node"

class VueCli < Formula
  desc "Standard Tooling for Vue.js Development"
  homepage "https://cli.vuejs.org/"
  url "https://registry.npmjs.org/@vue/cli/-/cli-4.5.15.tgz"
  sha256 "1b30ab732dd74684212623a1b25853905f3b788d4a2ddb5bf8de80107ee53bf2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7171017f898095cc831c3c23f3afeffd654f75a15842fa7f9ff6ed09fa961b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc4fd4beac5d07995847d8924bb26419aabfa16f2dfe3e78d1724584d2cfe7e0"
    sha256 cellar: :any_skip_relocation, monterey:       "4d0307e17d3d5f4fe5638d4ce24a6baa83209c4b77b1f802e862c383f0a3ebd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "184d76f9e670a16e5bbab3cf7c835358d1fa68f58a5d32c29a0e4bf2b5abc58f"
    sha256 cellar: :any_skip_relocation, catalina:       "184d76f9e670a16e5bbab3cf7c835358d1fa68f58a5d32c29a0e4bf2b5abc58f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88ed989cedb09ddd2a1b202499aa37627ffd7d0f501a9a763ec43e3d1d0f8664"
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
