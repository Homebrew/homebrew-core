class Taze < Formula
  desc "Modern cli tool that keeps your deps fresh"
  homepage "https://github.com/antfu-collective/taze"
  url "https://registry.npmjs.org/taze/-/taze-21.3.0.tgz"
  sha256 "a3cd18531b35d53417ddcf287363a650da3adf61129ca45ca6441d0e1edc1b30"
  license "MIT"
  head "https://github.com/antfu-collective/taze.git", branch: "main"

  bottle do
    manifest_sha256 "6329b72bb28cfa0f608b337d48dea63447be899fc9059c8cb312b0eae07ef2d0"
    sha256 cellar: :any_skip_relocation, all: "afa980aa86130eb11590958b349c78fe4ba3c5d7e9b09309a70663f088406063"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taze --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "brewtest",
        "version": "1.0.0",
        "dependencies": {
          "homebrew-nonexistent": "1.1.0"
        }
      }
    JSON

    output = shell_output("#{bin}/taze 2>&1")
    assert_match "Failed to fetch package \"homebrew-nonexistent\"", output
  end
end
