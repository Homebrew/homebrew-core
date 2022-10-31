class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.34.0.tar.gz"
  sha256 "fa6c7a9754a04afb62821ece6e0128ed01c9c89a934f2f8a7d7be2e5bce7ea19"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70f85da26bedc865ca591140655173d46a1156f6596f57d7e3dd217317519ea2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36decf7a22e1412fd4d959a4b12d6c9ce01a13b4dc4df5ec8d658a8e030867f8"
    sha256 cellar: :any_skip_relocation, monterey:       "f51818dd3c082118ef768b716db5538a366fa1521a6f8420e40b53965871c43b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2f22bcb71f07315661e66451591e862fdb8c19a790e3679a5c1a2e7be47b2e0"
    sha256 cellar: :any_skip_relocation, catalina:       "d2996bd0aaa5cb8d0940d0d8a3b316e324d7dc299c413f418696df711192f1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41811e49f2dc5f0992a98c166c4227254aeace54ca1ae733b0906d737e22bbf7"
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
