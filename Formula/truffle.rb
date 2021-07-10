require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.4.0.tgz"
  sha256 "f734df5ab7a1016a042e27ede87fc950b44a118fb31280a183f5bd8347933c48"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "412e37c91f24057b8619fda14f03c9ee422aa614be629b28e0c8a9004537be90"
    sha256 big_sur:       "69e9ff5ca5ead347a2b8856e92b26e15ed852913ef692e98b7a0171003e2263b"
    sha256 catalina:      "e689658d4817e997f6cb4edd988decbe92762134cb9ae1387be5e8f34b79c6b5"
    sha256 mojave:        "5cfffd42dee39e1ac94a63ef6c8e070ac46a82d4bb734fc29ef3d653b199d8c0"
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
