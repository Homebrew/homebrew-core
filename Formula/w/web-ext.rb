class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-8.5.0.tgz"
  sha256 "d5606bd27fe0b12a42eaa6ff9e63724bfe9ab364a8b70554296a54296c7cc4b9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a6b39a46f322f75b720c3d2ab0a1da299604bee775379840e7ec3bb10aba62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43a6b39a46f322f75b720c3d2ab0a1da299604bee775379840e7ec3bb10aba62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43a6b39a46f322f75b720c3d2ab0a1da299604bee775379840e7ec3bb10aba62"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb3d8899488651fc64b77cd9dac47bd00bbcb3b0d3d1f59f18c01146875be65d"
    sha256 cellar: :any_skip_relocation, ventura:       "eb3d8899488651fc64b77cd9dac47bd00bbcb3b0d3d1f59f18c01146875be65d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "388e499ff579e25f4860d20760e406b0cddc2cf3b54fe420b132fcb1d39f6d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b26e601d12086bc4af6ae46df03b66b532f729238576ed3140e415042925fdaf"
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
