class SpectralCli < Formula
  desc "JSON/YAML linter and support OpenAPI v3.1/v3.0/v2.0, and AsyncAPI v2.x"
  homepage "https://stoplight.io/open-source/spectral"
  url "https://registry.npmjs.org/@stoplight/spectral-cli/-/spectral-cli-6.13.1.tgz"
  sha256 "c9d8cec26445fece14db54835ddb1447e2adb23ca76c3aef6e7dc7c5a7f114a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a6bfa0d8037eae38d8e1eaceec0a8b6d6481a1e855ce6e7794116ef8719bf85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a6bfa0d8037eae38d8e1eaceec0a8b6d6481a1e855ce6e7794116ef8719bf85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a6bfa0d8037eae38d8e1eaceec0a8b6d6481a1e855ce6e7794116ef8719bf85"
    sha256 cellar: :any_skip_relocation, sonoma:        "54e0e0c0d078e8a456a57d53c1191aebdda0982cf67e04813c5b95d1a98c3cdd"
    sha256 cellar: :any_skip_relocation, ventura:       "54e0e0c0d078e8a456a57d53c1191aebdda0982cf67e04813c5b95d1a98c3cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a6bfa0d8037eae38d8e1eaceec0a8b6d6481a1e855ce6e7794116ef8719bf85"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
