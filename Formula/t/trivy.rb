class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "1b5acce5580a401998946d9eeb2aaa0312f243c001809a83eb9557efda628d2d"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccb57b00708da3c1cc428eb6ffc5c176591a24dda9f76e12ca07f11f51da4437"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5faae85d1dfae8bc098289011de33ab697520fbdd731394c0c3c62cfacffdba9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b7e159697c20889ba961fe16d0ae30995ba6a690fc1e5f4518589417523f6f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bda3a42009c33405de6155cf4e9ca2752cfa6ebbb5ae41d233d796d96a5b307"
    sha256 cellar: :any_skip_relocation, ventura:        "ae26257037aa13819f22f6c0148ef954c97d1c637c4c9f32c29561cd159fd74d"
    sha256 cellar: :any_skip_relocation, monterey:       "2e96fc9d9ef3c5453519a286eaaae60088f26f19f949c7eb8a63c4578a0ece6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af04d0c9ed31df18f75b904592fce9791883b0fdf2f4abcb9a9202ea5f92934"
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
