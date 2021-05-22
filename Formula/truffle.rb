require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.7.tgz"
  sha256 "92e119de1e1218f76fbfa96a2b0720cf7ca1934bcc31e7a9dc86969d7173e068"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "f89c21f5ecc30608673cdce8ccaf62178d73e69d5475628d7bc5a4947ac10c3f"
    sha256 big_sur:       "764b3a67eed44ac7b90ec63312326251abed167da1c421a88e7e03d740a659b1"
    sha256 catalina:      "914a221b5d35993a6f11d17253a25ab26af930e7ab842665fc2b185ab3a6de19"
    sha256 mojave:        "fd5eaf735352faa4430a4437b4f5b865e7d545ca164daebec86a8ca141327ab9"
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
