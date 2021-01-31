require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.1.64.tgz"
  sha256 "8e31ebf67b56c838b451556de5167263ba051a9104fea03d8d722709fd048ef5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "3d1a5e925f9d727e194645e6a81011ea29335985af9e457a9d2ebae7f5edfe4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84151c7dfa2734e0ee1c5452ebe7ce8069368eb0fe7020f50a8250ca73f9a527"
    sha256 cellar: :any_skip_relocation, catalina: "593d40a836e8a4839ba484ef3c611a6e2fcd576142ebe4589a41a60a5ab77b65"
    sha256 cellar: :any_skip_relocation, mojave: "35efcc9d7d72e8ebeb49d331ede34f3247df0fad3023a14ad333076ff49ec2a9"
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
