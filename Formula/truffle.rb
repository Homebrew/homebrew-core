require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.2.6.tgz"
  sha256 "da75a9b51489d293942e891ce74aad386c9f211ad11f03361e2dc270de1fcce7"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "35caaa5f3b5601759f266be6380b3367624d01006fb40acf93c5dc97169644af"
    sha256 big_sur:       "c7cbb0d90a8be439a9ac8ea70f83cb107bb572fcbeb640a99d37843900e3292a"
    sha256 catalina:      "aaaa0a6870404ff029c6ea661ee15cb3b8430d4e1f2d5f7a265d7c4133aa9955"
    sha256 mojave:        "f39fe43c10f85a8e86821fde8a98d5674380b310069bcbbafcd0085731ed75bd"
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
