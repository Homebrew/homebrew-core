class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.30.4.tar.gz"
  sha256 "1577d3596e03f6bc6769243b32e9da7d43e56ea3fff42d2551b2b81df50345db"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82c2d721cea0072905ab38e422fc62d37efa27e3dc6b5dc08ef280b2fd764f92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "585b0323b2fb2b9b40568b90853bfd574e060d3a77b5f6c19ed1be52ecb4e3eb"
    sha256 cellar: :any_skip_relocation, monterey:       "6761651000cbf1614e8b30e4bf7a3bf5cb1c2ee8fabca2306c66532f0c0e99d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e714357381eac2ee738cec77d32237308d145468bf5d087d7f331a06dc0d201c"
    sha256 cellar: :any_skip_relocation, catalina:       "77cd277d7eeb70bd179acdc614755e774f7aed2f174d63507df855837e58dc2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c343139c95f996577bbde2a96fd9c3f9613fde785bdfba8abb39dad82d7a15e"
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
