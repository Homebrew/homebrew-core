class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.37.1.tar.gz"
  sha256 "d13832058065d9d788835cccfe0bc917fdf45b3ede1033e23ca2f72977d67ab3"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f423fe002d09b03bda54913eef2cba013196c4f7661a400bbee6a43ed330a35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62a039a7ce58b1e51e6cfdcc150c800dcbcda6b821b5ae69d683ab9e0b94dc64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "566efb6e408ca536141606e1dabf19f0dd95287570a641b0d79f2baea5f46d65"
    sha256 cellar: :any_skip_relocation, ventura:        "b7ebb1376744b1662fce43b500fc3b08808f36ad049454d45571f88580265cd6"
    sha256 cellar: :any_skip_relocation, monterey:       "9140885a65c0b96b8c8291bc0c407d5711ae3aee7f82b8741d9df4c882cfef0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "16c58a4da201ce778b4ba4cfb98be5097b33349842ca2d74e84230567c769219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40e9bd661ae9cb92666802bda0734ff3613c2ad0630fa5ae0a8b350c026ccd72"
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
