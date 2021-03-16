require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.2.4.tgz"
  sha256 "8ccf0a988758ab308f7c71f82211dd517852504d4cc4319915d0dc364abf073b"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "a44d97614f79c7d39673f9f1870d919f1c704e1498c4c399c810a68e912c3239"
    sha256 big_sur:       "ace886e4e5dfb6c3226efdefaa33e1ce137ae5a302354ede1b0d10658fa36b0a"
    sha256 catalina:      "021aa50f02a728ceb26191b7d291aedc5cb80274f86ddfec0ab6f4ef28cce9ec"
    sha256 mojave:        "af6881f9b157a7d6a972d4c5957b9c2722b366ab882d1aed316697dcc354722e"
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
