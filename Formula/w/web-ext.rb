class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-8.9.0.tgz"
  sha256 "3b683ffbcb50c57e03b7ff5d9c4a118c1d9d04f834617d4809138fb3f1410295"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9a1364793914df6d1314d3bb33330ada02c91db769806803f1b92913917db45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3841f0cb6c0f92acc8ac16b33f6009e92059128b1e79fa2f848046489f92a83c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3841f0cb6c0f92acc8ac16b33f6009e92059128b1e79fa2f848046489f92a83c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3841f0cb6c0f92acc8ac16b33f6009e92059128b1e79fa2f848046489f92a83c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1d5c298d0399714d03afec2266ca86f9e47dee14fe83343c956f4a837adda75"
    sha256 cellar: :any_skip_relocation, ventura:       "c1d5c298d0399714d03afec2266ca86f9e47dee14fe83343c956f4a837adda75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c725fc7b120bdff7c405044fae2b39b937f159b2301549c9879dd1683b14c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c725fc7b120bdff7c405044fae2b39b937f159b2301549c9879dd1683b14c96"
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
