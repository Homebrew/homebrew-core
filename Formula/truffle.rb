require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.4.8.tgz"
  sha256 "cdd5036bcd9d074af4cc99d693d60d11585aaf594b4cfc931bad832327afa9f3"
  license "MIT"

  bottle do
    sha256 big_sur:  "e19199f2bbf2b232e212dd318400e942dbc12964c41dafb8c35418bd98ad4fe5"
    sha256 catalina: "dc5613eff3fc8c1707078fd7c27cbbdf8ec7fd65246a8a59aac881fc54e8a963"
    sha256 mojave:   "e9f83fb5a7e097f607b33b64934eb643ab7dc98be42fd00fefcd5e346c27bcd0"
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
