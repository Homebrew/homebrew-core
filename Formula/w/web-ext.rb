class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-8.4.0.tgz"
  sha256 "5dcddeaa63ca25a0cbb2ea641d12691af7f92e816f96d4e0f56daa31150f3e1f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aa682a7090e03e34a1041b3d9d54ecee870d7406fe7c8a40627fad229003206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aa682a7090e03e34a1041b3d9d54ecee870d7406fe7c8a40627fad229003206"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2aa682a7090e03e34a1041b3d9d54ecee870d7406fe7c8a40627fad229003206"
    sha256 cellar: :any_skip_relocation, sonoma:        "c997242418dc610143bfe3cbc2fa0c5773ab693485af4aa3706eaf6b4ccbe837"
    sha256 cellar: :any_skip_relocation, ventura:       "c997242418dc610143bfe3cbc2fa0c5773ab693485af4aa3706eaf6b4ccbe837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "679ff6e757ae6af8b40f2ea0ffb6e0feeb05145b9b09f260f5ac4c14e3ddd211"
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
