class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.30.4.tar.gz"
  sha256 "1577d3596e03f6bc6769243b32e9da7d43e56ea3fff42d2551b2b81df50345db"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95301f11b9080cc02a275f5d44955d31fccde1e5b94e56a3c3c7f87c16c9ae5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c84ce75235252ecbf78e4a06e009bb220e2d3e1821207a1617bdf085c5f91c71"
    sha256 cellar: :any_skip_relocation, monterey:       "55b4b1812beebc4f1559a241384f68474cd9722225ce434bc3c4ce1babcd7c56"
    sha256 cellar: :any_skip_relocation, big_sur:        "339dd5db2607910dd147e0a3fa46c47e078b28773a353f279c35276e011d1e91"
    sha256 cellar: :any_skip_relocation, catalina:       "cf969280c1af3230110f9ff61845c7992968639d98671632486ecd4207bcc6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "758837bde3d9ef7761f4fb538b4fa6a560eb7a796d5ce1d559ac4692d04e1634"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
