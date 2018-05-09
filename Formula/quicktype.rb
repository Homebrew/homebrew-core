require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-13.0.10.tgz"
  sha256 "e3781fbd3043b994182b8f03cdc733f3d864c9caf2f88e59866a9234b9e37aeb"

  bottle do
    cellar :any_skip_relocation
    sha256 "25f94c9eb3a252b872cc31f14afa823d4ccb571e368b5772fc739f9d3f605247" => :high_sierra
    sha256 "ea96065bec3cea590430887bd73b67bb99e32b30581b0a564c0782a412c1bede" => :sierra
    sha256 "768ab62712c9af289b10249a9d7bff4a0f94eb6ae11ddb6b468d493eb92b7fcf" => :el_capitan
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
