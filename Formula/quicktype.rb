require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-6.0.0.tgz"
  sha256 "f615dc2c026a3125039ba4463d8c931a7a771a496366c9aae252512a09a90854"

  bottle do
    cellar :any_skip_relocation
    sha256 "e477d04ce6766c778f8f9c36f01a6a01bba84944ff83d4e73e18821ae18c3cfc" => :high_sierra
    sha256 "9d470510581e83df4b5b88384091002c3cbd3e3d4bc63c8639318ae1e3161adf" => :sierra
    sha256 "0638e83312eb5ce1d861598a589cb25e592a03a3a4a468e3dde63c6b0c87e9af" => :el_capitan
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
    code = shell_output "#{bin}/quicktype --lang typescript --src sample.json"
    assert_match "i: number[];", code
    assert_match "s: string;", code
  end
end
