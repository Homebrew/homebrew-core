class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.29.0.tar.gz"
  sha256 "3e125b762cdf5ac9b8266c218648d975d1e91eb591c01d4c5e7dd32e5f665f27"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c28b192283ba0965089f96f4aa55f1253a0e1483a17f5bb5d1dfee0616f8f169"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1ab0e861f68fd45b31736d2fecb1d5b844e8a3e01f1f65b1576eaa4fa4654a5"
    sha256 cellar: :any_skip_relocation, monterey:       "6ade7b2f04cee4e1321b55bcdc66c42ab00cb217d005058b308fe4ac7efaf654"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e36422df509d12bfa038e9346845b54a84f4a53d729bf6c818ee0ddf8077cf9"
    sha256 cellar: :any_skip_relocation, catalina:       "4d7e0c524659600d3ac6454a0c314f5bdb3a251abd5c67b1e44193132c910bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdede51f4095f924a912e6c3505d3692171ac8c95098fed1f3763084c4f6b2e4"
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
