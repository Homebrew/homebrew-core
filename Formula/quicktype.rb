require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-9.0.19.tgz"
  sha256 "783717cf6b5da2557993db6329120d620ee901d0c5c888f9ef8a67391d3d6951"

  bottle do
    cellar :any_skip_relocation
    sha256 "43a760d02c697b542b7396348fe9f4314f71cc780fcf8db816f52fff19824e9c" => :high_sierra
    sha256 "81a4ef6e1e3e6d463dbd786524b48c01675e42e0883f0ff2014d8166faa69c2c" => :sierra
    sha256 "b1a7b8015bd016e1c1ffe58d11401c94f2601c96aeaf0ba14f2b84021c33df1f" => :el_capitan
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
