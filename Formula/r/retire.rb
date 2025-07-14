class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-5.2.7.tgz"
  sha256 "26d3361e0931f028acb0c4ef0f485a15af29c6a86136add471eb6fd7859b3e92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd6957ffffa84ce29986029c9d01eaf9382729bf0b1e207aa059681c5f0d1253"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end
