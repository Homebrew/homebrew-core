class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-5.7.0.tgz"
  sha256 "b48a548d44b2fbd71a4a0094281a9df10aac2ed81c1fae6bfeb1fa0c9a9b268a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bcb10ae3028a2512973c3f375988b51798be9331c015d33c11638e0d3026f282"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end
