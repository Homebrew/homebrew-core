class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.56.2.tar.gz"
  sha256 "239c0e33a87b7bcffb0a62567c26a009216ccd9192fdf11aad70af95365b2cbe"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5c9ebf3cfdcb16b8983edb58dbee88c4ab5d6b8f1bfbb71b441b1da355263a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e60fda2eae6b51c56ba931edbb8d14fe6b3de00f92f7abfb71783146a9b5006"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e42c7d017a0cf3d40ee782dc0816d696ee838d32972eefc1b2c63eb6b2845c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d60e5e62e5ecbe923d849211b520ce52dcf673860e7c0e0c7131b1a1aaa361b4"
    sha256 cellar: :any_skip_relocation, ventura:       "8f1806fbcd121934dc49b77565b5548824f885eca8c2469cf8fbad031db62e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa1c2bea8daffdc3e79d9d7c6335a41a6087b4bbc1d91a8710fa89d589b25601"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
    (pkgshare/"templates").install Dir["contrib/*.tpl"]
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
