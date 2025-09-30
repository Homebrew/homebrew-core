class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.6.0.tgz"
  sha256 "4032cbd9a03eefb25153c1a51d61bd2c48e68da1499d77f64ae75bf553f60d30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98869b4ad4ce138123ed4f45eb1e16248ff8b20038c4ae5fe4d2e1e61b88ef21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98869b4ad4ce138123ed4f45eb1e16248ff8b20038c4ae5fe4d2e1e61b88ef21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98869b4ad4ce138123ed4f45eb1e16248ff8b20038c4ae5fe4d2e1e61b88ef21"
    sha256 cellar: :any_skip_relocation, sonoma:        "98869b4ad4ce138123ed4f45eb1e16248ff8b20038c4ae5fe4d2e1e61b88ef21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cf3aec02878712f5a75fef37660363748010b9520011b32cc9e470b48af26df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cf3aec02878712f5a75fef37660363748010b9520011b32cc9e470b48af26df"
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
