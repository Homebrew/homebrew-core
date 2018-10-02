require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.130.tgz"
  sha256 "b5602fb164deacac1a306e0ff3e04b5e1fbfbef865be25e0a0af1ec0bc5cd5be"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6936c09bada8f96f57a3dfc9411a5473f8d8851335c661f5c045d92f6c76edf" => :mojave
    sha256 "4e141a172b2937788b214a1713bd9cb85a376b735c505c21d8d6ca975f2a3125" => :high_sierra
    sha256 "205c91ef38792785e68742698cad65d62db842c6b45218d0a4cd2b61116241c5" => :sierra
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
