require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.4.9.tgz"
  sha256 "9b79f5c146b3628444b2a7375271603500646bf6ae8a9c2275c4e5adfb5a4a79"
  license "MIT"

  bottle do
    sha256 big_sur:  "9e0902466bc7db35e4860686daceb4f03ad137c98baa934d2450f8068a76eda3"
    sha256 catalina: "8f8c4846414e94ea16898fd8d3258ca3f7b23e1cd53345348f84840801aeb9a6"
    sha256 mojave:   "593da748f15083a9b1ef3da0983ac4855e274a56afb5d679f3e407c6efd4d3af"
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
