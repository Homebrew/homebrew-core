class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "901c2887d58828b0d823da8a8cdad34f36648c272cd57700954eac6e24fd07d3"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97f98d99ca68b975195bb0e6db489ad5aa8c7f3417661d66fda706ae26d33b5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5232c413f3ef293c5c4581a8d2a71d9a7f03c7631c572922749c800a1093fdb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cebe82977301dc582ebdadae7dfcebaa4394825b383762c052698072d04a539a"
    sha256 cellar: :any_skip_relocation, ventura:        "90df959805dbaf2e9c34aee256563fe03e0bd0c5b2d64b6dc0b78a7eeb30c8e7"
    sha256 cellar: :any_skip_relocation, monterey:       "1744a1a9cef0fec711aadca532f7fff97ca3949151d2d17c56e02435cb8c6b3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "49d82093968dfd0cc814f4b5de5a732af92bffdd22c105169cd097025819ad37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7660eee2e57b9381f1d5410039e4b15627ac3020e954e80d9a632e53f81bdf44"
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
