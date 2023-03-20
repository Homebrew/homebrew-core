class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.38.3.tar.gz"
  sha256 "291161ddfe33fe0c49c66b8c379fbe665386912401891e32a0de0bdf2554d2d5"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5ebd298e6f9ab526a4b5b166c0cac642396cc43aaeb0991411dc2e28425fd92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "926a2275757c67c341466871b1b5803a075022177dd70e7d646e32167fab7de2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0830591b7d7ae2e52ad3ac540743f73c2d22a6e0cd772ae712f7d41f05d73c2"
    sha256 cellar: :any_skip_relocation, ventura:        "138020b69d80a395952f53a56c4ee79873b7bc1769012512b768c2a344662296"
    sha256 cellar: :any_skip_relocation, monterey:       "413f3aaa23065b59969cdb94c01fb8b62b014e107da021598231aadfeffd4194"
    sha256 cellar: :any_skip_relocation, big_sur:        "afb2106049daf90d2a56fcbb88d3de5552c5fe60e8682dc30619487f7944dbda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ea34bc70ec027a75869c022657523d8e4609e419ab9db1b5d2038d39333a364"
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
