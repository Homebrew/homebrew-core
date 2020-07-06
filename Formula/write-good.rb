require "language/node"

class WriteGood < Formula
  desc "Naive linter for English prose"
  homepage "https://github.com/btford/write-good"
  url "https://registry.npmjs.org/write-good/-/write-good-1.0.2.tgz"
  sha256 "7a69215e1fcf1f5cb376086e6e56c3e5e6113b34ccb2747157b2d84e4a53b35e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0a5d6df3a160e8c24ef47754fe05f88e369fc7140c45af5f6b1228beb52de0d" => :catalina
    sha256 "35c6923bda9539fa5704c7f9255b6590029503dcdf7b4d29090dc62a38aa1452" => :mojave
    sha256 "7b0bb14228cf6054bfad6d22a9df86e67b893bf49682a3706606e3fab1f7f40a" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "So the cat was stolen."
    assert_match "passive voice", shell_output("#{bin}/write-good test.txt", 2)
  end
end
