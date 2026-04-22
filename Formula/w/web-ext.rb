class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-10.1.0.tgz"
  sha256 "aaf961847e37da164f9afd77a061618c02d720a6acdb010ae606e87ca476c924"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cca4acf8ef2015cbb623a31aec5b3a2649dfdbb91ff9b1301ef66b6a7d029504"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cca4acf8ef2015cbb623a31aec5b3a2649dfdbb91ff9b1301ef66b6a7d029504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cca4acf8ef2015cbb623a31aec5b3a2649dfdbb91ff9b1301ef66b6a7d029504"
    sha256 cellar: :any_skip_relocation, sonoma:        "cca4acf8ef2015cbb623a31aec5b3a2649dfdbb91ff9b1301ef66b6a7d029504"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ab36e66668204365c0c7da1d45fff8a7c1d878d5e36d3c3cc8de5d9c94135e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ab36e66668204365c0c7da1d45fff8a7c1d878d5e36d3c3cc8de5d9c94135e4"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
      notices         0
      warnings        2

    EOF

    assert_match version.to_s, shell_output("#{bin}/web-ext --version")
  end
end
