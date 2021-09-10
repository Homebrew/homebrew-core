require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.4.9.tgz"
  sha256 "9b79f5c146b3628444b2a7375271603500646bf6ae8a9c2275c4e5adfb5a4a79"
  license "MIT"

  bottle do
    sha256 big_sur:  "e5ba980fa9c5c6fc5877c6547ce626f4d5bbe52f5bbfc91c2193aec9f3837130"
    sha256 catalina: "82edc3ebdb76e59633025faa2e5aaf645e0c1695c574e067f8182d74a761c4d4"
    sha256 mojave:   "e92dca57836a0394b96e281acf7d2e1ceb4672aaa663ad3c67e96b8e9a54304c"
  end

  # the formula does not build any binaries for arm64
  # see upstream issue report, https://github.com/trufflesuite/truffle/issues/4266
  depends_on arch: :x86_64
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
