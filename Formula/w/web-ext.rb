class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-8.3.0.tgz"
  sha256 "c653efdb1e8082f80512a1b635dea6b475748bff4f363f7e59e36fe0b4eb3503"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "847da99b4c45299aa173a610674bc9eea5881887d31f366b1888fbd9ba1e2cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "847da99b4c45299aa173a610674bc9eea5881887d31f366b1888fbd9ba1e2cb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "847da99b4c45299aa173a610674bc9eea5881887d31f366b1888fbd9ba1e2cb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "73a0f4a766251f92aef4a57637d12b6df26c52a55fd9d43de0bfa0f11b32b1eb"
    sha256 cellar: :any_skip_relocation, ventura:       "73a0f4a766251f92aef4a57637d12b6df26c52a55fd9d43de0bfa0f11b32b1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e311108a697d9f161f1b31b9068724ef0aca3729ca2b529bb7ccd9f298d801c"
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
