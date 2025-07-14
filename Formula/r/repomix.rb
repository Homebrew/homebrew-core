class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.1.0.tgz"
  sha256 "0dec3f94e8b0f50de2f0162ac4fac3c8b086aa49070324ad71698a8d1a95199e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef7de23aa9ea92d99d6232f036d143270fff15f4f07f8dfcca2015effa1043fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef7de23aa9ea92d99d6232f036d143270fff15f4f07f8dfcca2015effa1043fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef7de23aa9ea92d99d6232f036d143270fff15f4f07f8dfcca2015effa1043fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "66d5af8acf936344428e166ee38f992eed2f5d45d33a3c7d1c3a8b9049618b5c"
    sha256 cellar: :any_skip_relocation, ventura:       "66d5af8acf936344428e166ee38f992eed2f5d45d33a3c7d1c3a8b9049618b5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9278b5a31967d4b954da3b166b446088d335a9394c1f9e471f2629b181a7b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9278b5a31967d4b954da3b166b446088d335a9394c1f9e471f2629b181a7b01"
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
