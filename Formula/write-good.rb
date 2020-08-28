require "language/node"

class WriteGood < Formula
  desc "Naive linter for English prose"
  homepage "https://github.com/btford/write-good"
  url "https://registry.npmjs.org/write-good/-/write-good-1.0.3.tgz"
  sha256 "0c3e857846696947ae253bf776a46d4f0192636d667a8131adeae97bd9ad14e2"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "791ef8443c90d7b981052a43d2b6d2feca79764bb28ce566532d81a022bba264" => :catalina
    sha256 "b90b997569378259acbff13420edd45ad717e28a09e1bca30c224ba9851fa7a9" => :mojave
    sha256 "c9a25be0717ec2ed3d53768a212acc48d0a2d3ded2e21f15f51e9d8373764f9e" => :high_sierra
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
