require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.4.1.tgz"
  sha256 "b00866f5b331aae5430907db5e828d9017bdb52926effe5873e8b323c30940ac"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "c759a46df84acef755acf34f848261efd7129f90d5d58ded73d18a4a03861531"
    sha256 big_sur:       "2e7c7f3bd4d37721908b1e18a4d240a43f927a4c4d7ebc1a9fcf5322422c0c71"
    sha256 catalina:      "e23088721bee83961d7a02cc7549f77eda83e43289646ea0492a477fdc830c37"
    sha256 mojave:        "2ec9860c22ffc935cd608554113ee61a4224c0e1020786bb4fb96045998ecca6"
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
