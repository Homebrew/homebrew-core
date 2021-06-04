require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.8.tgz"
  sha256 "6e0602da4e92ae4b1682aca4c1b90a8a71f282ac58f3baf2ca14b04b55abb1dd"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "2952518ca7bc01c2045cbbf7fcb3e94e88ddccf0e68654d5dd40c696c6bd911f"
    sha256 big_sur:       "6b3bc2bdd739febb730fa54a003b9c91e5a5b416c2affb5c9dd2d8230f3a6f60"
    sha256 catalina:      "4500d70e0b58c8cb876358b80029f11a4ada504fcdc6c36d220e85e91ea71d89"
    sha256 mojave:        "c21f955d0c333ac0df316119c48059f9052c8eb5c9a3e98a7d3a8a9391d54f4c"
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
