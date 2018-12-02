require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.160.tgz"
  sha256 "78f8710596ce755853401c9c2e8b7919e8b157c4406fed6737b14427d3f8b1c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "39bb142639c93fcd81b2c42693d81bdc3260539ac5747eb944909a2298f96feb" => :mojave
    sha256 "2d59c6ce2b53d2f34abcb01c2784a3562e3cf6fa09a06f1e536821fefd4cb57d" => :high_sierra
    sha256 "c9d3db1bfceda4e5d9857a0d7446105c5b22fe29328a1620587e7798a5a727bc" => :sierra
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
