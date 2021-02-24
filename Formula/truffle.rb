require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.1.67.tgz"
  sha256 "27a313d3ab83f67bbd7da83e1b6d4bd5937a214a9d0ef5d0712f77d728fec603"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "57c44d201c49816548bbc27e7f9d95341738a3eaecee7371678103f1eaa64183"
    sha256 big_sur:       "9f3b0a71d34f4b60b0ce6c11e3e9f7072d7566c9b67124b402affad2406b66fc"
    sha256 catalina:      "e851c94371479dde7367624dfb041e9ed238d5fdf1d89b3d6ad258275ebb3a53"
    sha256 mojave:        "0b9ee454628db02b08b6d1fa90ee50b9746a9e31e50448a598399b080150493d"
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
