class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-8.8.0.tgz"
  sha256 "1efa644ae65069bf8b3c0a343fdd9bc500ffd0a0989999eb567a15fb2a49ab8d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51fad91b85c4d710f233be975765d8b8f4cd8710e01a84be697e50cb193b8683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51fad91b85c4d710f233be975765d8b8f4cd8710e01a84be697e50cb193b8683"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51fad91b85c4d710f233be975765d8b8f4cd8710e01a84be697e50cb193b8683"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d926fb0227b96570d70c26d7cdfbfe3f8650a298ef6886bbcdccdc6dcb101a1"
    sha256 cellar: :any_skip_relocation, ventura:       "1d926fb0227b96570d70c26d7cdfbfe3f8650a298ef6886bbcdccdc6dcb101a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5914c31daec581d29289a477f920b815d5133e1775780fe073894296b8981b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5914c31daec581d29289a477f920b815d5133e1775780fe073894296b8981b5c"
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
