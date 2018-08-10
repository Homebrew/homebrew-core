require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.100.tgz"
  sha256 "ea9ff46abbacf6c2969c8438e83f5eb1fb71b56c4580721d63cfacbb6273d56d"

  bottle do
    cellar :any_skip_relocation
    sha256 "264c50154ca5db714ce2f40574c624242c758d09c1061b2afb690a4a0706f935" => :high_sierra
    sha256 "d414399e37dc0016a6a2e7ed0a3bbc65f0c8b6dec6200de6e256ce70c0d79e6e" => :sierra
    sha256 "c06abd194844ca9b190d9b007c2f7419ad8c23bd5c7799564b247ade1f032cdc" => :el_capitan
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
