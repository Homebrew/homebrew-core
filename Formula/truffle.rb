require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.4.12.tgz"
  sha256 "5942d8502e9c6910967d8392bd5d2eae76459cef4639b1ab6468f404008a0bd7"
  license "MIT"

  bottle do
    sha256 big_sur:  "4ebf221683fa0b847990c03554b649f91c0951bac775a3c1e3cb4913ca735c5f"
    sha256 catalina: "6e3b7e053adb0997d8810c376291eb76d6e9bfcc6f671856f68e9de9384d5899"
    sha256 mojave:   "0d98f91261c6ccf68095237c1af41bc8a0693f6c2d3703f6c026a4c9defd2695"
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
