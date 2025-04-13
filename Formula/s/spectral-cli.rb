class SpectralCli < Formula
  desc "JSON/YAML linter and support OpenAPI v3.1/v3.0/v2.0, and AsyncAPI v2.x"
  homepage "https://stoplight.io/open-source/spectral"
  url "https://registry.npmjs.org/@stoplight/spectral-cli/-/spectral-cli-6.14.3.tgz"
  sha256 "804c2db75dc07f50c503e75b23833aec89bb6563f8a33e08d26bc8e0239fae31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01e31faa4731b14f0763311261d3618be487397f552c702419e83a04ca42aea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01e31faa4731b14f0763311261d3618be487397f552c702419e83a04ca42aea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01e31faa4731b14f0763311261d3618be487397f552c702419e83a04ca42aea8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c326ca57e88ae276c8d2248e46ea4cea5150514384c656431cbd4d2930a2aed2"
    sha256 cellar: :any_skip_relocation, ventura:       "c326ca57e88ae276c8d2248e46ea4cea5150514384c656431cbd4d2930a2aed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bcdcbb1fb3d677f318a2ca9c52b3fdc37b9cdf68bcf62dda238317900d96b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01e31faa4731b14f0763311261d3618be487397f552c702419e83a04ca42aea8"
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
    assert_match "7 problems (0 errors, 6 warnings, 1 info, 0 hints)", output

    assert_match version.to_s, shell_output("#{bin}/spectral --version")
  end
end
