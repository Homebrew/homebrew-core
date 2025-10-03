class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.6.1.tgz"
  sha256 "324bd42644e1b9b68076d378708073c6e2623d473cdd7ab8d37f02b40d750cdf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19fa21944f4ae451a04d2b2bc64c6d6b16522590f7380d558f70862596863ffa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19fa21944f4ae451a04d2b2bc64c6d6b16522590f7380d558f70862596863ffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19fa21944f4ae451a04d2b2bc64c6d6b16522590f7380d558f70862596863ffa"
    sha256 cellar: :any_skip_relocation, sonoma:        "19fa21944f4ae451a04d2b2bc64c6d6b16522590f7380d558f70862596863ffa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a49534b2113d45b81b4bdef5043618c1b9a0b6bac68b787903bbe04b9426dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a49534b2113d45b81b4bdef5043618c1b9a0b6bac68b787903bbe04b9426dd4"
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
