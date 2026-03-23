class Structurizr < Formula
  desc "Software architecture models as code"
  homepage "https://structurizr.com/"
  url "https://github.com/structurizr/structurizr/archive/refs/tags/v2026.03.06.tar.gz"
  sha256 "5b47d506ff4735bd2d52d5aedb546e1711a50c9042f6bfdc02e3f5dc2d1f91e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23b6747d7dcc0469f809c9cdcf28403fe30c92cd6bf59bc7de8a221188f4d5f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6118c897d07fae4aa3cae44b100ef7db432444d11c9f3d2b7533597c8982abd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf6b43f2a15abeb2d2abcd9ba6fc14ac2dfe303231ac80a1eddfaf8262cb0cfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfe13f558fbd106fe14e7ec7bfd3536edbda012387df1c2935161ee5d1c78925"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d0bc4f4c9a693a31d2e381461324b65c5f3e874881e9d9a871748b1fab45693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcd73da1fcfdd759004803edd2f2f49617860e30508ed277548b7e7de1f6a8f4"
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
