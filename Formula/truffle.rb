require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.1.tgz"
  sha256 "480bcd7f178fce6838c8c00625b9884e931f347bf99cd0f510289bf029add6bf"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "20ba7c4320eb868fb8f797038c8a0dfbb608483e0d833971ff3b0952c5a76971"
    sha256 big_sur:       "3072b39e6acd2e8e2715f4bee900552b41664a842cef716e9295a895fc0d861a"
    sha256 catalina:      "237e2e43f4e33d616d2aeff2eb32683a4c7374eecc1ef81321a30e4987e7cda0"
    sha256 mojave:        "acbfc7282ea631299768069fea5569a5ce791be7e25e741494f7da3b4983f2da"
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
