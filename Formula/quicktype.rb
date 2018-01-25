require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-8.2.22.tgz"
  sha256 "b9b0a76891da409164ce9180b2ca2ea3c8385646876f42a4a4c0d259b87dd42c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7aa43defeaaeef90716ade1c8d0c2c5086c6a0813fba11583ffc6c0d96a5bca0" => :high_sierra
    sha256 "c8731af1475786836e12b158d04e028bf3c02092d52db02e97249fa77b7e190b" => :sierra
    sha256 "4fb517ed4829259bc2799df43fcca58f2515e35b9a57a38c2a2099c9869ef561" => :el_capitan
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
