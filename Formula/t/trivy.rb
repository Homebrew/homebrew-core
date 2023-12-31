class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "228a9970abf610a740c469eb6c7384ab610d1644d53be00514c81da608e04d5b"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79284d20a86842da8ae7d83ea37610e08ffa454eddd4bd3cee2edc967e39d47a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e13e98b9793671ed09e745d4a07dd75631f9c49525a3671395b47b243fb76ce5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a45cbe511276bc527fc869051bfca50308a954abb390db1bff55d226acca5aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "716467a0964813b2b85dc2fc7717fa5e2e49b0d26e86160823bd35d68fd6b398"
    sha256 cellar: :any_skip_relocation, ventura:        "15b749d154900dd689567710559ccf2c536aab55349ec9cfb84b74eb3a10920b"
    sha256 cellar: :any_skip_relocation, monterey:       "1dd4d9b9b51e95b5099baef487b16974f1f00cde7a3c0a8e80785f2b8d5e512e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35f4ba03f07e9c7aa97b5b7e8c9492e5d7de9a1c83a12f7e6a6ab83581603295"
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
