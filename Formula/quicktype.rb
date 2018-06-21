require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.30.tgz"
  sha256 "92aca702ccb105c7d0e7a5efed30229fe0ed05dc2a3d24aae7d4ae3cf12c6dc1"

  bottle do
    cellar :any_skip_relocation
    sha256 "44cee1135f105a24d31d6a9ac26c96d8a24a53092ee0d7d42438ed68b2898fb7" => :high_sierra
    sha256 "5f23eaa7528f620b51511faa9b73436b55b334571887b3113a5c04af384d4ab3" => :sierra
    sha256 "55bd2677d02d859d5258336e22ebf2a64789114c8281f8fdc082374643039f7d" => :el_capitan
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
