require "language/node"

class SpectralCli < Formula
  desc "JSON/YAML linter and support OpenAPI v3.1/v3.0/v2.0, and AsyncAPI v2.x"
  homepage "https://stoplight.io/open-source/spectral"
  url "https://registry.npmjs.org/@stoplight/spectral-cli/-/spectral-cli-6.10.1.tgz"
  sha256 "f95fafdb871b94af24e7422e1453e8c114c5ed97cfe919f61ec0208949761a92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5059d48f313e2fe926979218140cc3d1170f7062725dc6ba6c5879a11f60985a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5059d48f313e2fe926979218140cc3d1170f7062725dc6ba6c5879a11f60985a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5059d48f313e2fe926979218140cc3d1170f7062725dc6ba6c5879a11f60985a"
    sha256 cellar: :any_skip_relocation, ventura:        "28df8a7164a6c8fd59d8e36cad9fd6752ae038b3b42020a29d4727ddf56490b3"
    sha256 cellar: :any_skip_relocation, monterey:       "28df8a7164a6c8fd59d8e36cad9fd6752ae038b3b42020a29d4727ddf56490b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "28df8a7164a6c8fd59d8e36cad9fd6752ae038b3b42020a29d4727ddf56490b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f310fbe0996f21cf318dbfe9e4b3552130f2cf64f9264c7c96d183c3d4ba6858"
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
