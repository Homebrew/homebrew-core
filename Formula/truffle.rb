require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.4.25.tgz"
  sha256 "a167f59c2267237cb9aec21805b4e3e5be71e3d02680633b48f62f8c3b38d4e2"
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
