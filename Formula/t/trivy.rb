class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "16fa56d6c3549657baa49f1de8ffef5b6a976d7bf11d378d0f097189b70bae2b"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c416e40e5468487c5da017cd8a0c2d7896e24d3502f5f96cad6e84a12b26969"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ecd67a4e09c233f72b30c8b9fd96c55be556c4ecb063184ac6d3ad9902529fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0539333b82906100e2c96e3bdf93324444790d6ca8614df120260dfeba3b67e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c20b667cf5170fe2c1442c8c0ca38cd63f19f2d0fdafd2e6b0756fc822ec4de2"
    sha256 cellar: :any_skip_relocation, ventura:        "921d9d412d22204de10042f169a5ae6a13bc029f744b5becb803af6531c1ce79"
    sha256 cellar: :any_skip_relocation, monterey:       "4b9fe7b5f73e233331f815a63d518f80a535a653ed3fef7bf717d88967914992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "210d24d75d5fb88d0ca9a0c26bdfa5f2f95a6f35c082acd5cd9f6af89241f00f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
