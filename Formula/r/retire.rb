class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-5.3.0.tgz"
  sha256 "e7b322111bec8b80b45b94d3276f4fe2e5ec986b835ee9c46d05d2a2de06a9b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f06986094a2890fe3bfa46cef5c6692a6a26c212106f3383522d5ed502ae3a8"
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
