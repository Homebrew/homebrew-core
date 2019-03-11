require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.170.tgz"
  sha256 "c4e2264054b54d93d6f5324cf3d7e60797cd7d481bc833006c33fabb65909860"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0d064fea40eb7ca433a5a62c9cefb9490b0d701090d3ff58de239de19e59f84" => :mojave
    sha256 "e69039279c0a63234ef350e9535d5de6fd7bf07d91bcf34f103302342e96bf4a" => :high_sierra
    sha256 "460c53194e9cd25acecd9e847181dfc9ac6652a73a0858d33326715f4631e2a7" => :sierra
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
