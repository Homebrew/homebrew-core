class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.2.33.tgz"
  sha256 "a3be73b3fc789bc890b0e1751c1bc7c3a9c6215452306bfcc0f5000c04dceb5e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4468a636c3999a4d60e15a79cb1ebd4c25490bb00cbd62c7af12b61e12caea1f"
    sha256 cellar: :any,                 arm64_sonoma:  "4468a636c3999a4d60e15a79cb1ebd4c25490bb00cbd62c7af12b61e12caea1f"
    sha256 cellar: :any,                 arm64_ventura: "4468a636c3999a4d60e15a79cb1ebd4c25490bb00cbd62c7af12b61e12caea1f"
    sha256 cellar: :any,                 sonoma:        "33fe47cfd59d993a07551de08d1b266db8e609674508e6a03a98eec13cb698bf"
    sha256 cellar: :any,                 ventura:       "33fe47cfd59d993a07551de08d1b266db8e609674508e6a03a98eec13cb698bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c3108203437f60af8e0522c7eb2d10407cb170c785ef37d1a01009c0595117d"
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
