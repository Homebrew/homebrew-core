require "language/node"

class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-7.11.0.tgz"
  sha256 "e3561fae3a56d2e645176122ebdb5bb3cd3bb60fee9ae9c921e92a0e521caa6f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ed58abfbfe9ec673a25cc89d2eb605fb1ce1f7368311955e140b4a5fe1dc7f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c806063f12a3bc0ff6d339e1e3e485d6f70db37d7745015c9cdccb1db09337c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4cc344463fdf9f6df3e3e19642ed3a893c403cc85932bb13896c9919030eefe"
    sha256 cellar: :any_skip_relocation, sonoma:         "22508d98eec560de68db0b125892134903c6a159cac86d8171e3bf1a600096c8"
    sha256 cellar: :any_skip_relocation, ventura:        "1a3b4a35bbd3d259e82945265c2e6072f1090ec4fbdbcb7d763f4fbbb13990b8"
    sha256 cellar: :any_skip_relocation, monterey:       "6e6f613f7453e96f47c1c1557f4e15c65681478a3628743a296acbfa55368f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b61797ceb75bc11976d6487200fdb86277a4cdb72afad7601601ac1d3b31b9d7"
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
