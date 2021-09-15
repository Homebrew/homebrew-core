require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.4.10.tgz"
  sha256 "ff46d40db40bc4c713818f059c19181f7f6e8df7cc73c521efbbb898275e4c91"
  license "MIT"

  bottle do
    sha256 big_sur:  "0dff9b022403a432163244be1bf4ed6b63e51e243b1843a4f6a7468e5646e4bb"
    sha256 catalina: "0d4b5a31cf47f2d103ac936dfe10dc2eb8606d94b717ca76284c4ab55d90eef1"
    sha256 mojave:   "06b584dbd5f25cdf9fcc8fda2b03e23b4a85ccbf0f87065bf6378b7109576405"
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
