class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.5.0.tgz"
  sha256 "48ca6b6c55c8d51aeaff748c6e646718f5fdec35418659974d9b0fed700fc868"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f28f9e9e660b51164a194e3d638727056abc7bd260e0b3b8cc38a0247d70363"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f28f9e9e660b51164a194e3d638727056abc7bd260e0b3b8cc38a0247d70363"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f28f9e9e660b51164a194e3d638727056abc7bd260e0b3b8cc38a0247d70363"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f28f9e9e660b51164a194e3d638727056abc7bd260e0b3b8cc38a0247d70363"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "915e1a9e387829ca72c75c4f8b412074ac5319e4cb90d56b56bf01cc66b6478d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "915e1a9e387829ca72c75c4f8b412074ac5319e4cb90d56b56bf01cc66b6478d"
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
