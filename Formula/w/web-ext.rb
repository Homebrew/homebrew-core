require "language/node"

class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-7.8.0.tgz"
  sha256 "227ce577a95005d8294e6bf1ca0ae5f345a5dfa98f9f52c91be977ada96d7fa6"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "beb1d9eef6a50ddb7146112dcdd6a7a7453ce440ed9847e7b57d7c10a52d84b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c27eca9aa5fbf6252a462b978f460748f38d7f859beceb110c54b16ecf34100"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f33db3fe55397911af10f6a73ea9d6453db1cac164b61765653c8cacdc07cbed"
    sha256 cellar: :any_skip_relocation, ventura:        "974af2d0d8c0f9a8de59def9299edb93b2860f5958c27d5e8c9f5a750605f913"
    sha256 cellar: :any_skip_relocation, monterey:       "e243a9036f681f6680b517cc35d77087cfed38b5838b1f2412521e1dc9262c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70df45eb94c5b74da01af8d93c0d91f1771a235fe02f9b302c071e5a159c9dc8"
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
