class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.3.8.tgz"
  sha256 "641984012fb7074125666a1f295049345108b1658fd04c494299303bfc07bfb2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "38936461c20551512c9276384d6be45639dd9a28dda7475f8fed35f34eb74ae4"
    sha256 cellar: :any,                 arm64_sonoma:  "38936461c20551512c9276384d6be45639dd9a28dda7475f8fed35f34eb74ae4"
    sha256 cellar: :any,                 arm64_ventura: "38936461c20551512c9276384d6be45639dd9a28dda7475f8fed35f34eb74ae4"
    sha256 cellar: :any,                 sonoma:        "b643fffeb292e68f3a2c037d768fe90326307325c7a13e0eb88b7881d9e3695c"
    sha256 cellar: :any,                 ventura:       "b643fffeb292e68f3a2c037d768fe90326307325c7a13e0eb88b7881d9e3695c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c4e884de18c0c45bfc674c96118dc271c26e50e6678bd0bcae87fc2a5eb9380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2306fe2914394be276217d523cda5554e59eb4dc0279b1ad796115f220224d2d"
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
