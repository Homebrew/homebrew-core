class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-8.10.0.tgz"
  sha256 "c1f66a6eef82c85b592b0ab66e16ba899a74729220cfbec3736f3743dbd7a924"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ac796c0cc872da49cc738c9a8551020c39bf5f31f90f1e8af71b5831e305a4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ac796c0cc872da49cc738c9a8551020c39bf5f31f90f1e8af71b5831e305a4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ac796c0cc872da49cc738c9a8551020c39bf5f31f90f1e8af71b5831e305a4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ac796c0cc872da49cc738c9a8551020c39bf5f31f90f1e8af71b5831e305a4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a38f5e9b14c8420dbbbb898be65ed77b47a0821a504b4e81efda78e8616b1387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a38f5e9b14c8420dbbbb898be65ed77b47a0821a504b4e81efda78e8616b1387"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/web-ext/node_modules/node-notifier/vendor"
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
    (testpath/"manifest.json").write <<~JSON
      {
        "manifest_version": 2,
        "name": "minimal web extension",
        "version": "0.0.1"
      }
    JSON
    assert_match <<~EOF, shell_output("#{bin}/web-ext lint").gsub(/ +$/, "")
      Validation Summary:

      errors          0
      notices         1
      warnings        0

    EOF

    assert_match version.to_s, shell_output("#{bin}/web-ext --version")
  end
end
