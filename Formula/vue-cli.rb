require "language/node"

class VueCli < Formula
  desc "Standard Tooling for Vue.js Development"
  homepage "https://cli.vuejs.org/"
  url "https://registry.npmjs.org/@vue/cli/-/cli-5.0.8.tgz"
  sha256 "29aa4eb0ba827624e42683e1339ebd40e663ad09836dd027df30e3d2108b0b71"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f3ffde156f1616113d4f4f4f899964e96ba0787a4fe21b50f73f973d416fbe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44b550780fa0274fd769599d39e267e47f1ae8e3508ca935afd739c389d75a17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44b550780fa0274fd769599d39e267e47f1ae8e3508ca935afd739c389d75a17"
    sha256 cellar: :any_skip_relocation, ventura:        "4c98f36032ccb36802e6bc8e6baea973d45e73d44630b49e3f1d0c40d938792d"
    sha256 cellar: :any_skip_relocation, monterey:       "6daa1544d8d602d0291c7206aa8833bc62a9b2f0c5a2b5c016d5cae3ce2bb1c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6daa1544d8d602d0291c7206aa8833bc62a9b2f0c5a2b5c016d5cae3ce2bb1c5"
    sha256 cellar: :any_skip_relocation, catalina:       "6daa1544d8d602d0291c7206aa8833bc62a9b2f0c5a2b5c016d5cae3ce2bb1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918bbe94743ae4eb7124cdfb5f9d42017602e19fbdf899b88795c6e367a6dc5c"
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
