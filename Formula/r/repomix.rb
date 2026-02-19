class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.11.1.tgz"
  sha256 "011c9a566f3373288d2139078e3713cc0bcda1cff33fa704949f085a83cb16d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1b7a94d155284fc9754a51b8ae5abf7d27e65b092c881018f183b8f66fe087c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1b7a94d155284fc9754a51b8ae5abf7d27e65b092c881018f183b8f66fe087c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1b7a94d155284fc9754a51b8ae5abf7d27e65b092c881018f183b8f66fe087c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1b7a94d155284fc9754a51b8ae5abf7d27e65b092c881018f183b8f66fe087c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f11029164a2cccc856e262250f8c054d4ff0c2ece7a25acf77e992800df49d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f11029164a2cccc856e262250f8c054d4ff0c2ece7a25acf77e992800df49d6"
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
