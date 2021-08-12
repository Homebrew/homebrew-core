require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.4.2.tgz"
  sha256 "14d39217ad146fbf403c2e19a2f4cce43dcc3608d397d171f34602c69f187a29"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "b27596eb084d98167858eb09bc42ac0c63a52bb55ea4061f416da0e4c3b5ee14"
    sha256 big_sur:       "ec2f4faf1b68a7e810d46476b9214d12c884ecaa0bb9378b26d118125371650b"
    sha256 catalina:      "2c182325584bd5dcd013c61ac50cecd6a41490255fdb2fbf043ab297d78e02d9"
    sha256 mojave:        "371f862ca3584732e155953d816355a8ecb0db7c45170cc97c884efcdb165692"
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
