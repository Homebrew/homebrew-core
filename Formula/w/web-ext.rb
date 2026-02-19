class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-9.3.0.tgz"
  sha256 "5ac3c63d30450eab2eda422d5a3ead475bf1f989e783cc5331eb639fd92d1993"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c20edd20fb75182c6d3bc69700c942e66de7c241d9e6fe75b1990924dcb2895d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c20edd20fb75182c6d3bc69700c942e66de7c241d9e6fe75b1990924dcb2895d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c20edd20fb75182c6d3bc69700c942e66de7c241d9e6fe75b1990924dcb2895d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c20edd20fb75182c6d3bc69700c942e66de7c241d9e6fe75b1990924dcb2895d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29222581e9850dfd651541b1f188ce1a4ff24dab0b48d288bd285d80b8ea2c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29222581e9850dfd651541b1f188ce1a4ff24dab0b48d288bd285d80b8ea2c8c"
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
