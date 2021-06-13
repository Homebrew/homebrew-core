require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.10.tgz"
  sha256 "4bbec1578072e583f1452ab0f18843d2718890a35ab3885025719ddd93d4b530"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "6f1a9b3be1a54c731b73b41181b06ca635a667971875e3ac81efa299b6545ba5"
    sha256 big_sur:       "29ced5da16278ef1ebbf8f3c3eb754cf3d71b898348d640e476289c73ebbc60e"
    sha256 catalina:      "67136893a001e9666c2f5ee47baec9dcc685729fe4ed32735045e10df5100ba0"
    sha256 mojave:        "086aff2085057bb2a4f937caa9e82171fba48cd785a7c47db55f9b9130c82cbe"
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
