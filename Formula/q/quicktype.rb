class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/glideapps/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.2.6.tgz"
  sha256 "a8cf7412ccc3ce1c04b1083cced2c47b0b7b043b77fc56cbef5c151aff2c9daa"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1f596c091f22130c5e3365124d67bdbbc0076d062d65e1fdb8e2f7e4a905f17b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    JSON
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
