require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.250.tgz"
  sha256 "fcb83430f3d539a9fec35adb2e884672e65997c8f0c45e245993378bca2cb362"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8a722266b1d434cd898838d36e67ed444e8e34699ddeae6ab10367725fd2ed63" => :big_sur
    sha256 "b821ed4fc0888190e632f424bd75767bdcfabe26bba5b21af7f51a81451de88a" => :arm64_big_sur
    sha256 "0e8a066590d3379759d8d5edde1a572f1c0af2bdbd8b0794e18f574db4c3a567" => :catalina
    sha256 "2905e11643e1f66851b8fda1ff00788b624297726ece95f5a6992a9da1a94766" => :mojave
    sha256 "af0fc0f564639712090a95dcb8876710851b56c1af32d6121eac0fdb978b5996" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
