class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-8.7.1.tgz"
  sha256 "574c1caa9265b6d47c5aeb907df0d189196c8b70273e523f96650922ffd678b7"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ae8e47f8043f1e795c071c8f97580ba32eba2f300dc4017726f3b1a2a0777a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33ae8e47f8043f1e795c071c8f97580ba32eba2f300dc4017726f3b1a2a0777a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33ae8e47f8043f1e795c071c8f97580ba32eba2f300dc4017726f3b1a2a0777a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f60e52a9832aeeb3cfeea89a0107ec2638e18de4c0b67fdda42047a9c231d26"
    sha256 cellar: :any_skip_relocation, ventura:       "2f60e52a9832aeeb3cfeea89a0107ec2638e18de4c0b67fdda42047a9c231d26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7a001e6d87af957d2406a8110a80e94dc5c4b22c311442e9274fb0e0933d560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7a001e6d87af957d2406a8110a80e94dc5c4b22c311442e9274fb0e0933d560"
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
    assert_equal <<~EOF, shell_output("#{bin}/web-ext lint").gsub(/ +$/, "")
      Validation Summary:

      errors          0
      notices         0
      warnings        0

    EOF

    assert_match version.to_s, shell_output("#{bin}/web-ext --version")
  end
end
