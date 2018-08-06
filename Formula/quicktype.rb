require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.90.tgz"
  sha256 "9090ff20f7c93bc900e461ec6cea459323fbfb652829ac5e353a93e35d58a475"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bcdcf05a64ac80f4433ab4fe7ad0f4d8ec126b4a9a001db075b98cf7cff483d" => :high_sierra
    sha256 "0637b0416f71d672d12468f13237a0756d39c662defc59dc50ca363347e323fe" => :sierra
    sha256 "050350e47272a00ddbc88e80dd12f50c6f6486588e59e3929a95ee3480d17b05" => :el_capitan
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
