class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.9.1.tgz"
  sha256 "1e8b3209709be03e1357fc6d1484da4510fe5a3dab35343461e6eb15bb61cbfa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f09f8664802eb35884baa9c29f91667713a879c6a1f240cec4027ffc7309f15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f09f8664802eb35884baa9c29f91667713a879c6a1f240cec4027ffc7309f15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f09f8664802eb35884baa9c29f91667713a879c6a1f240cec4027ffc7309f15"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f09f8664802eb35884baa9c29f91667713a879c6a1f240cec4027ffc7309f15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "524d179b3f4825b7534a7d8760d2078c0fcf900ca852dd660035ee114a97f9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "524d179b3f4825b7534a7d8760d2078c0fcf900ca852dd660035ee114a97f9b2"
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
