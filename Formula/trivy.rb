class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.38.3.tar.gz"
  sha256 "291161ddfe33fe0c49c66b8c379fbe665386912401891e32a0de0bdf2554d2d5"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a7f4bf35a08040738f6c17904481a5d70704c4b9288ac9f73b1a78deb62b281"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55f4b29484512a561c154b42519b249e7773ab4fc01b2a1f56cfc423f0d5c722"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a50d11c9f8159f19dfbefddfdb9673ec3f52a9473cd7f7e97e230ee712a10050"
    sha256 cellar: :any_skip_relocation, ventura:        "095778a5a5022bec8ca8fa757aeeb8ecadbee7a5c0c6d7fd2b498d97886168bd"
    sha256 cellar: :any_skip_relocation, monterey:       "316f9f7b32f36be8499b7b78c0bdd669179576af1bca5c72feb4a525983e3a44"
    sha256 cellar: :any_skip_relocation, big_sur:        "0edcb4a145af763e5321c97fba6ce28606b742df7ffbb0900ed5fb54dd28f91d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b2c640fcf34e16ba44914d5e4dbf5727a21169e040fe1a9f5c2b9af3ff1d17"
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
