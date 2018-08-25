require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.110.tgz"
  sha256 "d9c62baf4c04a79a0608ec7f6747b320e1c826ae7cb0900604491e748147c7f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "5aa5ee5a295f7a4982a990e2715b8d4ed49b742de672664981d5aa2a6912e59a" => :mojave
    sha256 "a8149409f6914ca0b552507f6bc0d58ee96f7ac938a41a071d35fd98ee35c2f1" => :high_sierra
    sha256 "b6a0307ec9064fc8134ef8b1921f422665ae71f9554f0a1b91a271512ea6132e" => :sierra
    sha256 "0dfe47a5dd54ee42fc5278ea7cd9bfde228a8afdf76ca4f0b3a3402f4a6cafaa" => :el_capitan
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
