require "language/node"

class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-8.1.0.tgz"
  sha256 "7ff2d85615b5dacd5787e993d503b31da39920ebcdebe98542be70850421ac4d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1ca6c2cf528937cd97300605c73b7cb74ceb0dfdb2f872e383b6e7f499a850a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad0bf2327a2bdfd96de3c642510fe48eff4b3669983109bb216466ab59d77621"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05d7e1905609bdf52e4078901a47e98fc383dceca4eac1515485b0fd348d8283"
    sha256 cellar: :any_skip_relocation, sonoma:         "77703d3898f7587155f80dc0d621a5290bec2b50e5355b1a17ce671e001badd7"
    sha256 cellar: :any_skip_relocation, ventura:        "dac97c9877fc4ac9b4130a3c0b789b9a3bff43b12c1cb42c561875995818b83e"
    sha256 cellar: :any_skip_relocation, monterey:       "9b11603a86ec782db701b79a3382eb844e30c6a23ba00df8f75bd8cca5fff36a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a1ea20987c9d7fe569ac6bac9f062d44818686645bff6ef87104bcbc858d6c0"
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
