class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-8.2.0.tgz"
  sha256 "b29f14cd9f909fe7714c518527a2f6fffdbc9182cdaa83690eef07cb3fd77e1e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48142765f68650ddaac03558ccb58318e6e6438580b4b734f4d2753baefbc818"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b164c30476dbb984922b5e40b6470fb6079a547e7b9d1b5bcd5b1307d13cd412"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e7360f97526ee4dbbab843c5922e151469555ecc0af493e516e117e354d5340"
    sha256 cellar: :any_skip_relocation, sonoma:         "0701520e4f7b454a8d62f3884176a95441ec8f64340887e93f24bb833ef7b774"
    sha256 cellar: :any_skip_relocation, ventura:        "991d4dc4579451a5c1dc91c4b045e30a5131f2deffa92cdccdf311e9628f969d"
    sha256 cellar: :any_skip_relocation, monterey:       "7ec46ce0f5409217e729d9dcb11ca324ae40d0412b329925680fdfa9114f176a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e19d476e945cb285263fbba68f94edbefd946e66beefe20147558e494bef51"
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
