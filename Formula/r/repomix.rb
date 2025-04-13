class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.3.1.tgz"
  sha256 "541a352c47322558996439f0b5551c9e18f4173e3cb9800ef6813e5332d3d413"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c243e8e09953934ff02d9272b91da3b096dc720111014b116a5d3c0283954491"
    sha256 cellar: :any,                 arm64_sonoma:  "c243e8e09953934ff02d9272b91da3b096dc720111014b116a5d3c0283954491"
    sha256 cellar: :any,                 arm64_ventura: "c243e8e09953934ff02d9272b91da3b096dc720111014b116a5d3c0283954491"
    sha256 cellar: :any,                 sonoma:        "fbb781f816e3cc173e68dd50f7374b0e1bf862bdb133699f792fbcb77f8e90ff"
    sha256 cellar: :any,                 ventura:       "fbb781f816e3cc173e68dd50f7374b0e1bf862bdb133699f792fbcb77f8e90ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ce369e450dbae8fcdf4247782600f8385da30dd5e2f5c72bc700b2db3775ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2278b623f378054f42d85124e60dd77bde85f0436cebec510fdfb5e988a71c0b"
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

    output = shell_output("#{bin}/repomix --style plain --compress #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end
