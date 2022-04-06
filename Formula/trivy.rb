class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.25.3.tar.gz"
  sha256 "b052f1767499ba0d24220e68ada387cef4bb22cef18ef051185f18ee4347252c"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09c4ab665ba852563648f8f338355caab1745407eb7416c16f3610f191726eaf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e9ad67d5559004ab785cab6c86f0e46be64de792a64c76282acb3cc1f15545a"
    sha256 cellar: :any_skip_relocation, monterey:       "bec9409d3d80c6e9ee8ac234c739ae60a4d95cd19ccc40dbca6e31c8bbf3c357"
    sha256 cellar: :any_skip_relocation, big_sur:        "29c31ce1f98fde8de055323b15755f4a6b483ab3350e0e31477153174c6cae99"
    sha256 cellar: :any_skip_relocation, catalina:       "95155a5faf63c9ff6ffe28117821f6dc74d4cc7e7f5294837135d29b4b7cd4b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b00e95f3398f702715f3fe1f7233bb8101cbb600d8e51692fc20228ef374e6d"
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
