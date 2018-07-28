require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.70.tgz"
  sha256 "7cf83c33e8a1494c67a6025b7ff97071b49a1374686c6d7cfb69db7788888d6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "feb79f46d39196bd81f5806d7152c40c6688b9ea5579807c5c7742fdf5d943fd" => :high_sierra
    sha256 "e15a67b9dca25f0bddcf627235303e139b2162938503ef7e6da219ba1741bfc1" => :sierra
    sha256 "391bbd2484e6aa16ef05eecd89c1d8703d8811cdb8c68fbcdcda5bb7d484b898" => :el_capitan
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
