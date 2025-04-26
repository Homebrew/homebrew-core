class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-0.3.3.tgz"
  sha256 "36d294da22c19f72888b3021e6acb183b422317b80ec612e5bfc9b9bcf185151"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd2ff64ba145890a9ae5235ef022e329117d20f01ab60cc04aaf9f5e6774ca85"
    sha256 cellar: :any,                 arm64_sonoma:  "fd2ff64ba145890a9ae5235ef022e329117d20f01ab60cc04aaf9f5e6774ca85"
    sha256 cellar: :any,                 arm64_ventura: "fd2ff64ba145890a9ae5235ef022e329117d20f01ab60cc04aaf9f5e6774ca85"
    sha256 cellar: :any,                 sonoma:        "0da5ffdd8407e2db3e2b403a068f9ad9aa821103683c23d4177eb373bf8fe852"
    sha256 cellar: :any,                 ventura:       "0da5ffdd8407e2db3e2b403a068f9ad9aa821103683c23d4177eb373bf8fe852"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05cc1a2845a9834145f0503aefa0c1445b966b575e82a9b677049f9360f92188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b536befb5da11f82b4af5c4febee83755be4797715a15d91984d52019338806"
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
