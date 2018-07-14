require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.60.tgz"
  sha256 "13e1b3c753284ffb80428bb7acea9b5b0f1c0cbd7dec218d3cb7053b1b98b140"

  bottle do
    cellar :any_skip_relocation
    sha256 "be647f8bd17e3ff23eee7c3b6679a62ca831de50fcd9727eb7d69aac554f6165" => :high_sierra
    sha256 "1c6ad3c5c5cf1036537232947c679413efe0662975dfcda5c1979e4e4f1df7ee" => :sierra
    sha256 "248f750ae76f1ba99cf10f601a3d9021950d8597ac0b1f6d20373021f504f1dd" => :el_capitan
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
