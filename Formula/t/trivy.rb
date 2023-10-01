class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "126c27556d8fb2603d06e68fd7a5220a0c66fe17f9236e1adfbb625792977f7a"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cab142d11a93b22010753cdd0e2de1d73fa57cb50815405ed6cd82076a6f5e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0577c014c20424581063e76691004075d78539d4120784212047443ab686732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "025c0f146f026e5ec650a46e8f15d493975160dd1f047f52be288a122ad7bf51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e079578df6302ece1b6032f526e2c53f6e26e3c0387976047201fa931fd62c58"
    sha256 cellar: :any_skip_relocation, sonoma:         "e81ba269095dc9da9dcf3fe59de395096726d1ef39ab4355f843ab44846c63f1"
    sha256 cellar: :any_skip_relocation, ventura:        "7a18d9f4dcabf64cc7b5dd63cb411bf7dff1656b1021da229a133b2af7613aa2"
    sha256 cellar: :any_skip_relocation, monterey:       "f7d5d3667d83e43f75828fa9ebb877797bf850d1fd902854a390ac4c3fb4077d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6873eb7ef4bfaefc6ca0777b5772714f975fb72c5215c1574423fdc54c848e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e99d86b13814e68ee3e7241da84b5af77b875136fabada2f3d6cf8afb106f59"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
