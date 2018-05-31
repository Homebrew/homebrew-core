require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-14.0.0.tgz"
  sha256 "eb829d347fb8d611c0c85b434fc311c3d24679d0a013ce77bf8a659e09737c14"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5275d797ef61a84431623c72f7a2d7f5f649add1a8e321bbe905dfde0840c3d" => :high_sierra
    sha256 "01ca8d9de25ba79b90fc41bb329caedc02d8b5847d8ea4a1bfbd732812819fb3" => :sierra
    sha256 "e952d0e4c22becb65ed4f64a45e86f5f3f907ba7abeaf8ff887bdd0989d0628d" => :el_capitan
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
