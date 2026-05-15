class Structurizr < Formula
  desc "Software architecture models as code"
  homepage "https://structurizr.com/"
  url "https://github.com/structurizr/structurizr/archive/refs/tags/v2026.04.19.tar.gz"
  sha256 "f757f53fa418a285248ba44bd2b3b0869a202ead295421e5f65a7013cc68ce94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bcff291047778459b459feb71ada9d9229cfc2ea37746f8de75820a9c560ea9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e77dfee4c6f7046633faa4b7f97feac1f8b11ecba9b4e03452edf6ba73c507e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65fa477d875707f1ee4b412bc11d662fd460458d2fdc0abd8333ead9568b28a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b7c03373de84a4801d189e5267bd5e72a96aa1b6c4f89071e01e6210c346114"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f58360faa50a5318d5d6467ee7a2b433255e03c8f5c8575b3cf6b43a22bfb2c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc8ec9af84099ac75a39f88a7ae5a0d2208dc2eb9a6cf8be52435fe9d918e610"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "-Dapp.revision=#{version}", "-Dmaven.test.skip=true", "package"
    libexec.install "structurizr-application/target/structurizr-#{version}.war"
    libexec.install "structurizr-mcp/target/structurizr-mcp-#{version}.war"
    bin.write_jar_script libexec/"structurizr-#{version}.war", "structurizr"
    bin.write_jar_script libexec/"structurizr-mcp-#{version}.war", "structurizr-mcp"
    # NOTE: excluding structurizr-themes due to unknown license for PNG files
  end

  test do
    result = shell_output("#{bin}/structurizr validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr: #{version}", shell_output("#{bin}/structurizr version")
  end
end
