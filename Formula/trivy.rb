class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.25.0.tar.gz"
  sha256 "42c956ec41dad926437f099c983d24029713a18a3d3a26706f1db64df8f1dd20"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5a473c8090790bbb45a7aeb5d878008d03a7986fce4142973ddf2682cfb900c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92f5fb6ce130f23c9696cd03f0aefd6d1696aabd0951a2a54d53cea2dc3a1dd2"
    sha256 cellar: :any_skip_relocation, monterey:       "1b834e550b178eea1a89c3bb230e8f1554b09a093e389da912bfa49a57343250"
    sha256 cellar: :any_skip_relocation, big_sur:        "a09afa0cec5531c92602690fca2b85712b71d61ac82e68f10950f14bbbdc35bc"
    sha256 cellar: :any_skip_relocation, catalina:       "5ba2e4ab7b8a80d5b13e67370e16230a26f7fb782bd52ebb7e94b631115d7be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc553b6e1bcbb8d39aa687f79a94109a977e89e971377355f6ebf1563545b0a6"
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
