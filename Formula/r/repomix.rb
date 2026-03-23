class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.13.0.tgz"
  sha256 "0db3240241ca7d4a293bfd89f6d2ebdecf38f583dbfe712e7840c2a1dce8da54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdecf26e38c3eb19974d4d421fdff5854192de66f99bcb1c7d3c9c1838b935ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdecf26e38c3eb19974d4d421fdff5854192de66f99bcb1c7d3c9c1838b935ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdecf26e38c3eb19974d4d421fdff5854192de66f99bcb1c7d3c9c1838b935ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdecf26e38c3eb19974d4d421fdff5854192de66f99bcb1c7d3c9c1838b935ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f91b47ff480cbd9387ce4081149b59f7f10eb32e0b52f95c6007fc1c7496b348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f91b47ff480cbd9387ce4081149b59f7f10eb32e0b52f95c6007fc1c7496b348"
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
