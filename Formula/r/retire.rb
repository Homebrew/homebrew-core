class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-6.1.2.tgz"
  sha256 "5f386e2189098a7db476d460f6e5d5c83888cc97700bbda913cc7a632ed00d89"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "8b34809854fa77760ad621c1a24c067e7330711426e76a808c01be14e5d6c30c"
    sha256 cellar: :any_skip_relocation, all: "c2b652ec63bf3295fda5a3b9ff9cd24ce01ed6a96119836186e6a990fad47b28"
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
