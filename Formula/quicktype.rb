require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.10.tgz"
  sha256 "dc758d5f97800b922358d4b3e2c89fa1528022ad1103a2e7909413e50d2494dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "d43e280de9e483613d2dba429b6a72e11ec1a86926ccbf7f317a604466120549" => :high_sierra
    sha256 "fd884c8e6640a0a910a9b44685cb1f67f2ebac15d4c2da7dc5a830c47fed37bd" => :sierra
    sha256 "3e07fead9990511850fc21a3f69de74ed3c09af8f0afafef7d362070b08c0709" => :el_capitan
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
