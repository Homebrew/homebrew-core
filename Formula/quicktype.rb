require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.160.tgz"
  sha256 "78f8710596ce755853401c9c2e8b7919e8b157c4406fed6737b14427d3f8b1c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd5ff21d05787bbc4f00136fbbb763e76ec909fbbbe559d7e031a7a4e031c353" => :mojave
    sha256 "113a536930c4c950122ed00e55d30f7999da8b19c5cc33c83a66a8a3f49bedce" => :high_sierra
    sha256 "13761db950b5fb839570fb1ecb57b6b4802b0c1d9a891b5d439af9843cafb796" => :sierra
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
