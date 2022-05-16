class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.28.0.tar.gz"
  sha256 "fd95e5353c7e834c87f4a6dfcf7ccbc390da5e0dc9287cedf341a7b3c5dade9c"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88d64a390db9361cdf387f92dba12e720d824af4076c9e21fbdcef843933a673"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b673fe8c9abef9fe54bf6417e951628d87b4c4b6d970e89e847cefb316a201be"
    sha256 cellar: :any_skip_relocation, monterey:       "518abc5347fd017a35891746270359845ef9d42430fbb98e43df51fd58204166"
    sha256 cellar: :any_skip_relocation, big_sur:        "67e0bce13bd39bb03d27ff62b047c9700308147801a58c8209c822edb867c163"
    sha256 cellar: :any_skip_relocation, catalina:       "d0d60fab894c7dc38546c71661b822318e984b6112aa85f46c89b4f7e5f7f97e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17ca9decef0dad1a5cf113b91c3aec9452a6315dcbfb849e652bd713ae38dde6"
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
