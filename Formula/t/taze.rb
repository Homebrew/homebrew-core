class Taze < Formula
  desc "Modern cli tool that keeps your deps fresh"
  homepage "https://github.com/antfu-collective/taze"
  url "https://registry.npmjs.org/taze/-/taze-19.9.0.tgz"
  sha256 "14d09cd3dd24edd91929f43388887fe96e948b6e70884461eeaae3e6c14e9dad"
  license "MIT"
  head "https://github.com/antfu-collective/taze.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "91faaa3adfb15b50c9aeaef32712cc86647bdf8c6afaeced532ec7b914ca958b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
