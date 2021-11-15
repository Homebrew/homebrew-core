require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.4.12.tgz"
  sha256 "5942d8502e9c6910967d8392bd5d2eae76459cef4639b1ab6468f404008a0bd7"
  license "MIT"

  bottle do
    sha256 big_sur:  "c39fe4aef87c1c78a58b1d7dd791519e2e608a9b1eddf9c4865c4a42626f3c23"
    sha256 catalina: "dd0c6c697882c291dd6e697ed430f2c864a5f1ebe38544a3d563507c5dc5dea7"
    sha256 mojave:   "5b19919e36101ef6cf0020a3a75b8087a5a766644138ebd8a08893b9765503cf"
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
