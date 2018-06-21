require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.30.tgz"
  sha256 "92aca702ccb105c7d0e7a5efed30229fe0ed05dc2a3d24aae7d4ae3cf12c6dc1"

  bottle do
    cellar :any_skip_relocation
    sha256 "61aebf2e29353af2f4fcb7480b39119c386c74663ed1d6b789cf1b3a40e9d1a4" => :high_sierra
    sha256 "7b98f1d4c6bdb3e96c4a70d2998f03e8070665573139621301519049fbe420ad" => :sierra
    sha256 "1d59cf3f8c81a7c9e26344524225161aaa2f1ac23ad4ff2dff70cdd22c2e5798" => :el_capitan
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
