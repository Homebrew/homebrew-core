class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.24.2.tar.gz"
  sha256 "ddbffec10e32de2dfbef14169028d60df7504ae255ac674febbafdcf61c7906b"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2325ed114e1194ccc2255ca67908f3e5948210e2f24f88633645925ac9bfedad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba1e675cc2e125705fceae766d3cc51654130b637a0e7838e5b6ea0ddd6ccf3a"
    sha256 cellar: :any_skip_relocation, monterey:       "d79ce54b156b1807144bc3b707b08bc280d9c8e03fa7ebd47c9dd322b5b5964f"
    sha256 cellar: :any_skip_relocation, big_sur:        "285f58e72f911e6909f58a0ea5933982c3fd2a99ba79ddfad7e74e2fdbd15d7f"
    sha256 cellar: :any_skip_relocation, catalina:       "93e03e0cbeee342a252c6414767c295c9ac76e958343fc80eebca2f84575a97b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8db7ba233e267b59b5494c63db7ef74f397e27ea920c9ca09c87e1f2370fa34f"
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
