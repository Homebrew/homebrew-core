require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.8.tgz"
  sha256 "6e0602da4e92ae4b1682aca4c1b90a8a71f282ac58f3baf2ca14b04b55abb1dd"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "7141e78fcc75b403ee9aca5ef63b02f4d98158d0af745257ecbd456f675e17ef"
    sha256 big_sur:       "a0cd17bbf6ec536b9653cf3e36fd8d12ee74406e4e8ecc2f196b5975ba85a785"
    sha256 catalina:      "0b13f1c52c929b04079109689ecc69c2f114e9d12ec0b5b787e2a6f61f6becf0"
    sha256 mojave:        "fc45be69ecbe080cc00421012d5da7aabaa269ee4ff571934bf675dd856c9c3c"
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
