require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.10.tgz"
  sha256 "4bbec1578072e583f1452ab0f18843d2718890a35ab3885025719ddd93d4b530"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "dc38d054d84b6b7a140341861983ba24e8b6f2548f1ff6eafb0f3a556ec905b9"
    sha256 big_sur:       "ab8d30aa6f724a8491c843b41d75360404171e67f0593c135731819c15c47582"
    sha256 catalina:      "fd74e17f89b581cbd641965016246065c40f5bca7b28d4755585c89e4e3cb0f3"
    sha256 mojave:        "65f1b30621f1a450295e3d0a280ca2004fc510ee80364cb98080b98772fc6703"
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
