class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.2.34.tgz"
  sha256 "9185d896bcb10cf358e6ba343a8dccd68df4f4cca094666adc5f3c95da885ccc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de6c08cea504a7b82379ea751bc3f9c451f3466ff0cff5aa5f570c276933e078"
    sha256 cellar: :any,                 arm64_sonoma:  "de6c08cea504a7b82379ea751bc3f9c451f3466ff0cff5aa5f570c276933e078"
    sha256 cellar: :any,                 arm64_ventura: "de6c08cea504a7b82379ea751bc3f9c451f3466ff0cff5aa5f570c276933e078"
    sha256 cellar: :any,                 sonoma:        "767c2a0e036a7cbdcf1f17784c2cec2ff13ede2670e0283928e4724aabc52210"
    sha256 cellar: :any,                 ventura:       "767c2a0e036a7cbdcf1f17784c2cec2ff13ede2670e0283928e4724aabc52210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51083ff87a3f16ecdb76e59c3affc0fa2dcbc9558cc8c283971b8f1487da2051"
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
