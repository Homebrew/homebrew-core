class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.12.0.tgz"
  sha256 "a7a9fec646dc94117d1642ed79a623bd1a84d77b12282a431332624e351e120f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa5c2a1a810bc65bdf2f73e0a7aaceb70584a791bd8201738d78b6134660a959"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa5c2a1a810bc65bdf2f73e0a7aaceb70584a791bd8201738d78b6134660a959"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa5c2a1a810bc65bdf2f73e0a7aaceb70584a791bd8201738d78b6134660a959"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa5c2a1a810bc65bdf2f73e0a7aaceb70584a791bd8201738d78b6134660a959"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd844a3e2e5db205f5897e9d007bf50cbb4cb1c20a30f64f3885b841daf8fde1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd844a3e2e5db205f5897e9d007bf50cbb4cb1c20a30f64f3885b841daf8fde1"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
