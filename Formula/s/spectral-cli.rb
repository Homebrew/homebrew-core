require "language/node"

class SpectralCli < Formula
  desc "JSON/YAML linter and support OpenAPI v3.1/v3.0/v2.0, and AsyncAPI v2.x"
  homepage "https://stoplight.io/open-source/spectral"
  url "https://registry.npmjs.org/@stoplight/spectral-cli/-/spectral-cli-6.11.1.tgz"
  sha256 "def3583f144cb7ba6d03d6814167ab3d6a8a27fff7f575b2c2ec72f0b133cc0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e08c2b1224176536f59c282b2cf22437bdd90fc3658074939509c2b16129c47f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e08c2b1224176536f59c282b2cf22437bdd90fc3658074939509c2b16129c47f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e08c2b1224176536f59c282b2cf22437bdd90fc3658074939509c2b16129c47f"
    sha256 cellar: :any_skip_relocation, sonoma:         "143cec713103b5cf1b550eb8764f063c0e936706080a984388346c4d2a2c2492"
    sha256 cellar: :any_skip_relocation, ventura:        "143cec713103b5cf1b550eb8764f063c0e936706080a984388346c4d2a2c2492"
    sha256 cellar: :any_skip_relocation, monterey:       "143cec713103b5cf1b550eb8764f063c0e936706080a984388346c4d2a2c2492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e08c2b1224176536f59c282b2cf22437bdd90fc3658074939509c2b16129c47f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource "homebrew-petstore.yaml" do
      url "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/b12acf0c/examples/v3.0/petstore.yaml"
      sha256 "7dc119919441597e2b24335d8c8f6d01f1f0b895637f79b35e3863a3c2df9ddf"
    end

    resource "homebrew-streetlights-mqtt.yml" do
      url "https://raw.githubusercontent.com/asyncapi/spec/1824379b/examples/streetlights-mqtt.yml"
      sha256 "7e17c9b465437a5a12decd93be49e37ca7ecfc48ff6f10e830d8290e9865d3af"
    end

    test_config = testpath/".spectral.yaml"
    test_config.write "extends: [\"spectral:oas\", \"spectral:asyncapi\"]"

    testpath.install resource("homebrew-petstore.yaml")
    output = shell_output("#{bin}/spectral lint -r #{test_config} #{testpath}/petstore.yaml")
    assert_match "8 problems (0 errors, 8 warnings, 0 infos, 0 hints)", output

    testpath.install resource("homebrew-streetlights-mqtt.yml")
    output = shell_output("#{bin}/spectral lint -r #{test_config} #{testpath}/streetlights-mqtt.yml")
    assert_match "6 problems (0 errors, 6 warnings, 0 infos, 0 hints)", output

    assert_match version.to_s, shell_output("#{bin}/spectral --version")
  end
end
