class Slopcode < Formula
  desc "Open source AI coding agent for the terminal"
  homepage "https://slopcode.dev"
  url "https://registry.npmjs.org/slopcode/-/slopcode-0.0.3.tgz"
  sha256 "8c07775397fbf38e9c1aac8f839b5b093ac9fef691768ede1302c98b4e3c9909"
  license "MIT"

  livecheck do
    throttle 10
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slopcode --version")
  end
end
