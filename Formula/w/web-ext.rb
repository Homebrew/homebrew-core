class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-10.3.0.tgz"
  sha256 "db22a9a0ea05e5b1e3d694ebb7c437444d563d95956f5e915f64eff2321912d3"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bbf8db1d9ec74f35ecb38c3c58f6ddcf37eef64038a08050e13c932a48362794"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
