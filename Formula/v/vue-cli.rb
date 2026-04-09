class VueCli < Formula
  desc "Standard Tooling for Vue.js Development"
  homepage "https://cli.vuejs.org/"
  url "https://registry.npmjs.org/@vue/cli/-/cli-5.0.8.tgz"
  sha256 "29aa4eb0ba827624e42683e1339ebd40e663ad09836dd027df30e3d2108b0b71"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "99415c2c2a9d3487c7bd190b79d63434126556c6afa2ccf482e618b52b071c7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3b72fda6c0563cd941f67f7fcff7ce0562af8f248188775a0409c7c26e23a2fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c106882fcbc2627f6939d21aa711c75b8781a49a846b0a2c64a3a48d230f1bd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c106882fcbc2627f6939d21aa711c75b8781a49a846b0a2c64a3a48d230f1bd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c106882fcbc2627f6939d21aa711c75b8781a49a846b0a2c64a3a48d230f1bd6"
    sha256 cellar: :any_skip_relocation, sonoma:         "566e867488804efc1ff36499d3abaf6d5d20bae6173f8577f54f8d50b120b6e2"
    sha256 cellar: :any_skip_relocation, ventura:        "566e867488804efc1ff36499d3abaf6d5d20bae6173f8577f54f8d50b120b6e2"
    sha256 cellar: :any_skip_relocation, monterey:       "566e867488804efc1ff36499d3abaf6d5d20bae6173f8577f54f8d50b120b6e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0f08dc625a000e5e23fb2ee9286233e8b9e2d3893cb091280423d3276919beba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f068d7c069a1dae0ecbba18a4537d4816d55d6357ff9feb4806923ee486e92e9"
  end

  deprecate! date: "2024-12-22", because: :deprecated_upstream
  disable! date: "2025-12-22", because: :deprecated_upstream

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/@vue/cli/node_modules/node-notifier/vendor"
    rm_r(node_notifier_vendor_dir) # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end
  end

  test do
    (testpath/".vuerc").write <<~JSON
      {
        "useTaobaoRegistry": false,
        "packageManager": "yarn"
      }
    JSON

    assert_match "yarn", shell_output("#{bin}/vue config")
    assert_match "npm", shell_output("#{bin}/vue info")
  end
end
