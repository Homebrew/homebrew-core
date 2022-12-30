class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.36.0.tar.gz"
  sha256 "52a9bf424934d68f04ff75a50e1daa792a3b733d80528c301c96f6249f46b47c"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb00399637e559724f6e25a6bb02064d16086073581375c1853d70ab3dde0fc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c580dee2b424e95bb2e19062ecff94fe4ccc605e16cd307a7eceba458ab7b62a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0cf4d928dc3efbd2ef579fe8ddc47923a1df62862251c1a434c63daf3ad8ca2"
    sha256 cellar: :any_skip_relocation, ventura:        "a6efd7205dc7e087d1a32b5c26f55bdc440c71732dafae957c96c22ecd2664f3"
    sha256 cellar: :any_skip_relocation, monterey:       "7413f012331291393151c7343220ac7d9278184f829fe262fde6463e3ea4ed01"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1eab6c6f7e73bd98bad78bfbc4bc2938f6ba29c418dd7c498e8709af812b38d"
    sha256 cellar: :any_skip_relocation, catalina:       "9c5d5acbc141728d485cdbbf5a08d0a4eec888212ac02b493a8a556b38057cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3444c66c3a43876cf2e5c82fe831d1295a51212d57b7948c2326f2cc78ad031d"
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
