require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.3.tgz"
  sha256 "f8ac89b0f97ce52ca89f964966aafc8d0dc33b53341f68245bd1a1776f973477"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "45e4c112fa76989737c470d8de5d29e82c8490db92cfdaf04201f666ee2bf534"
    sha256 big_sur:       "fe87c4bbcfdb17de80e964cf53ac04a4f9919dd927b00978d069c0b537fecb61"
    sha256 catalina:      "7074b484e0d5f1092ff864501e9d19b0f01a631b3be0013007c46da19a421871"
    sha256 mojave:        "e6b55d01ba82445c5237fe01e829672026e4fa511aae6734805cd0134ab6d396"
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
