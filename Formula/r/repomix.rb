class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.2.22.tgz"
  sha256 "43a65a2cd72fa12176dad55758835d07482bbc9e9b1d53af1e24dd8fe96566b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a8bd24a7988e6928065f8c405ec0e30f750ab5537866c31ed011245aa345d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a8bd24a7988e6928065f8c405ec0e30f750ab5537866c31ed011245aa345d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0a8bd24a7988e6928065f8c405ec0e30f750ab5537866c31ed011245aa345d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "460ca6b7c7801cb5704dba7c01b4086ceeb8244e5fb7c130c18c0dbec4202610"
    sha256 cellar: :any_skip_relocation, ventura:       "460ca6b7c7801cb5704dba7c01b4086ceeb8244e5fb7c130c18c0dbec4202610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0cc8a7843357d62ab4461e01fc555bd2c48663a9ba8cd61397b1b7bdda18469"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repomix --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repomix #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end
