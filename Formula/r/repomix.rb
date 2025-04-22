class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.3.2.tgz"
  sha256 "2cac5fc2908837a38f7dc2f2ab805e5459b19a729de50289792e24279428e980"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3b6c686eaf38506ad8a99af6273f49b81955e3b3507c24832b2b6f96cf867f9"
    sha256 cellar: :any,                 arm64_sonoma:  "b3b6c686eaf38506ad8a99af6273f49b81955e3b3507c24832b2b6f96cf867f9"
    sha256 cellar: :any,                 arm64_ventura: "b3b6c686eaf38506ad8a99af6273f49b81955e3b3507c24832b2b6f96cf867f9"
    sha256 cellar: :any,                 sonoma:        "bcda22b1d9963541aee40868d0fd5c76eda7db8ea2894361d26ec3081a48462a"
    sha256 cellar: :any,                 ventura:       "bcda22b1d9963541aee40868d0fd5c76eda7db8ea2894361d26ec3081a48462a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9448b1dd9162bfb56799ba40ce1365afd96117da066038b641228d5cee670da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af13e2564029a2289a68e815733baf6f83b8fb455fcf946a8bcbb737488589d9"
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
