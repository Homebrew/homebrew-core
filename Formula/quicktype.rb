require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.200.tgz"
  sha256 "cc921e796121b2b5e5e1afa71e56585ecd1dc53e21f1de599ecb7381dd9e9265"

  bottle do
    cellar :any_skip_relocation
    sha256 "565095a5049e3e4192dfa9a3ca777bdb9a92cca685a2c2e158be54033e8474f4" => :mojave
    sha256 "68ec3310a3dc7a9984cf3768a5f9f5413e3658ec14acf0f6c165d915e8f4fc18" => :high_sierra
    sha256 "ae61994a52d722d9781ed41f173be08f975c209b1bf335e51246697339369828" => :sierra
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
