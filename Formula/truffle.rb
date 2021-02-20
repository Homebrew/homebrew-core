require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.1.66.tgz"
  sha256 "f0c8bfb6a7ef6fcab182ef1d2acbb3106742ef888dc3ff3fad32ae18e94941e3"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "f1d6e2b1ad01280aa232bd3932648a21c33764595a67cb61bc0ab793cd15c24c"
    sha256 big_sur:       "d8eb1afb5157bd8adbf96f67208c1204dcc9f563b75e2ad418ca5dc5936fe2a1"
    sha256 catalina:      "4cd0864b4ecf2b0357fc3be9b54e139a982b6a73c9c6f3554299ad542a32b982"
    sha256 mojave:        "91af51c4f9e2fd72b48cbf53ccd2ee805737d39092633db9c61913ecd1811798"
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
