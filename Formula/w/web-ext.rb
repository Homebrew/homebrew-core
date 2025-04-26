class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-8.6.0.tgz"
  sha256 "9dd91f59688eaf393d9747dd400ab2237707852b86625e89b4a7dcf54998a69b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16d39dcfde70dec4e7e2b7b6e6ba843ef737228dd7b0a3320dba59225d00d328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16d39dcfde70dec4e7e2b7b6e6ba843ef737228dd7b0a3320dba59225d00d328"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16d39dcfde70dec4e7e2b7b6e6ba843ef737228dd7b0a3320dba59225d00d328"
    sha256 cellar: :any_skip_relocation, sonoma:        "70aa1809d22b9f0eca46c8333f36bc8c889812ff93ab2c7ab482d1a53c87863d"
    sha256 cellar: :any_skip_relocation, ventura:       "70aa1809d22b9f0eca46c8333f36bc8c889812ff93ab2c7ab482d1a53c87863d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fb8fb6d672ec59260ebc2659da6565ea928d16ea5e537cedc00e5bb99687c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fb8fb6d672ec59260ebc2659da6565ea928d16ea5e537cedc00e5bb99687c11"
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
