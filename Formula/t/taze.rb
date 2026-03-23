class Taze < Formula
  desc "Modern cli tool that keeps your deps fresh"
  homepage "https://github.com/antfu-collective/taze"
  url "https://registry.npmjs.org/taze/-/taze-19.10.0.tgz"
  sha256 "0e7faf25b4e1bd35c291b878b2870114e9147172358033c77b138ddc20dc761d"
  license "MIT"
  head "https://github.com/antfu-collective/taze.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4cbb2fd5ec0618a9ccd28a7ebac7d9206ffd84517d92b18b644f5188eefb232"
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
