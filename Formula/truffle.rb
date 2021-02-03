require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.1.64.tgz"
  sha256 "8e31ebf67b56c838b451556de5167263ba051a9104fea03d8d722709fd048ef5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03fdff6fd123950c8a97caf58ba7b2359e3289018810aa4a128a5529be80da36"
    sha256 cellar: :any_skip_relocation, big_sur:       "b075416984afba971b1710aec06e2725ee8c6d267c8c51bfd14734d335cf28bf"
    sha256 cellar: :any_skip_relocation, catalina:      "996dc05117812640ec131a9dfdecde0e960aa994448cdfce420f83232da01a28"
    sha256 cellar: :any_skip_relocation, mojave:        "f3e9a3bff2ed3e0060eed6853c0fc3e44619d2bf0aa65fa9bc2033a68696fab6"
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
