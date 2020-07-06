require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.240.tgz"
  sha256 "8d33ab80b03db7996d226eab38935505bd073c6d9ed75ca3db77fef0eabd6298"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6dcb4ca8f02a79d042691aa9780ff118421cbb00d6dd1dff170c0f5880e1e3e" => :catalina
    sha256 "b9a4a53503d75d0a6e31b67d52688aa484819abd5e539621cb0ddffd0892eeb2" => :mojave
    sha256 "840ae4619f54bb0f2e70e1b1580be76a1361c0fb15deb559d3897f2381bdd52c" => :high_sierra
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
