require "language/node"

class SpectralCli < Formula
  desc "JSON/YAML linter and support OpenAPI v3.1/v3.0/v2.0, and AsyncAPI v2.x"
  homepage "https://stoplight.io/open-source/spectral"
  url "https://registry.npmjs.org/@stoplight/spectral-cli/-/spectral-cli-6.11.0.tgz"
  sha256 "57400e36f33236df82ea06b7513244b99276201d35195c8f9c781d479afe64a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6aeacf5b951ccb06f453238d28cfe2d1d1da156e548822d1d7826dba74265cd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ef33221a2c02526be1e6d8c9e6b07cc18dc23b55f82dc73d8eb4c234720d128"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ef33221a2c02526be1e6d8c9e6b07cc18dc23b55f82dc73d8eb4c234720d128"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ef33221a2c02526be1e6d8c9e6b07cc18dc23b55f82dc73d8eb4c234720d128"
    sha256 cellar: :any_skip_relocation, sonoma:         "e660bc784f8669841e3ded67bdf33045420738dd107b10f607743360c9e5cc7b"
    sha256 cellar: :any_skip_relocation, ventura:        "df52506dd10de2bead141fca23ac1f69f0e996cd2532663f7c5bd17cd1e5f736"
    sha256 cellar: :any_skip_relocation, monterey:       "df52506dd10de2bead141fca23ac1f69f0e996cd2532663f7c5bd17cd1e5f736"
    sha256 cellar: :any_skip_relocation, big_sur:        "df52506dd10de2bead141fca23ac1f69f0e996cd2532663f7c5bd17cd1e5f736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e9efa1cfedc0e266e00441e4e525fe8e94df60a698b4df182633d20acfd956e"
  end

  depends_on "node"

  resource "homebrew-petstore.yaml" do
    url "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/b12acf0c/examples/v3.0/petstore.yaml"
    sha256 "7dc119919441597e2b24335d8c8f6d01f1f0b895637f79b35e3863a3c2df9ddf"
  end

  resource "homebrew-streetlights-mqtt.yml" do
    url "https://raw.githubusercontent.com/asyncapi/spec/1824379b/examples/streetlights-mqtt.yml"
    sha256 "7e17c9b465437a5a12decd93be49e37ca7ecfc48ff6f10e830d8290e9865d3af"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/@stoplight/spectral-cli/node_modules/fsevents/fsevents.node"
  end

  test do
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
