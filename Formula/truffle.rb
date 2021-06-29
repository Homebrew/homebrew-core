require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.13.tgz"
  sha256 "7e22d8d947008ddc326fdb9c9d30a85fb748c92ff39a4996c3a7a4f5c5d18743"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "060c03aa8c310d19f4d18bdaecce6a0e94e1984627a7c77b1fee9a375a467f97"
    sha256 big_sur:       "cd5916882724774556401c1eb9b17e715387569f6bf6292f6665f61b2c4f2637"
    sha256 catalina:      "21b8184c33342956dc1434922f602715b82d6f5c46c35eff1fc33bf279c32887"
    sha256 mojave:        "30e3eb4fee3f05b0459beee1177a74f94250ac44121f8859e58bc6cc65131f29"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"truffle", "init"
    system bin/"truffle", "compile"
    system bin/"truffle", "test"
  end
end
