require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.150.tgz"
  sha256 "d23db3d1310b11b72ce9da3f9917af0141a82c3141fe8f39941c4e429e9671cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "897ad777336ef4cfc5a2e9c4b7e9c7cf44ed35a5e0c3c8f02b71bc82400c63df" => :mojave
    sha256 "3fe125138f065f10731544d4e03b9b46afca0a5346dd62ec8055406c47e97f9b" => :high_sierra
    sha256 "5fc62948168e90c83ea2ddebd9e9f375369353e721be2b3bb304265101f20777" => :sierra
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
