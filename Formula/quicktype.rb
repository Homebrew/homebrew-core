require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.200.tgz"
  sha256 "cc921e796121b2b5e5e1afa71e56585ecd1dc53e21f1de599ecb7381dd9e9265"
  head "https://github.com/quicktype/quicktype.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9c375ef085f9fcdc566d03ddf112d6d909f9f971e367e3ea18fade97ad691be" => :catalina
    sha256 "bae953c4acc58450f65424f3b4efb64da7b950c8c9a3cb6e9b61bb4138a31610" => :mojave
    sha256 "ba3c712342dfc08a2b8f093341bc5e3137e631e466ee99fad695c97653b248f2" => :high_sierra
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
