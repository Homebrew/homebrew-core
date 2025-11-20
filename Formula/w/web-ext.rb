class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-9.2.0.tgz"
  sha256 "b02a4ec95bfdd91a019a853040d36af82d7412707a39e25c2f577ca7770f1151"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70128e42bf3cea91b742b508858993a413f14fe7399c5eb4ba7cf51753d50577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70128e42bf3cea91b742b508858993a413f14fe7399c5eb4ba7cf51753d50577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70128e42bf3cea91b742b508858993a413f14fe7399c5eb4ba7cf51753d50577"
    sha256 cellar: :any_skip_relocation, sonoma:        "70128e42bf3cea91b742b508858993a413f14fe7399c5eb4ba7cf51753d50577"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2931720cbc5389c47bb53120c135f4b26b564dd7e5fedd700fcce440a75b9ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2931720cbc5389c47bb53120c135f4b26b564dd7e5fedd700fcce440a75b9ade"
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
      notices         0
      warnings        2

    EOF

    assert_match version.to_s, shell_output("#{bin}/web-ext --version")
  end
end
