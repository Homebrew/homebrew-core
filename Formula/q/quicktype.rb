class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/glideapps/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.2.6.tgz"
  sha256 "a8cf7412ccc3ce1c04b1083cced2c47b0b7b043b77fc56cbef5c151aff2c9daa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c804cee1f8c4c54167df12bb1cd6eee3c23cad34bc3b452c7c0fc399b55fa6b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c804cee1f8c4c54167df12bb1cd6eee3c23cad34bc3b452c7c0fc399b55fa6b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c804cee1f8c4c54167df12bb1cd6eee3c23cad34bc3b452c7c0fc399b55fa6b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "85cf7a232e3aff58c70b8cbd76d73f2e9fdfb6831264c9bcead6c20289c01ccf"
    sha256 cellar: :any_skip_relocation, ventura:       "85cf7a232e3aff58c70b8cbd76d73f2e9fdfb6831264c9bcead6c20289c01ccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c804cee1f8c4c54167df12bb1cd6eee3c23cad34bc3b452c7c0fc399b55fa6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c804cee1f8c4c54167df12bb1cd6eee3c23cad34bc3b452c7c0fc399b55fa6b5"
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
