class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.26.0.tar.gz"
  sha256 "44ce2720b3fd99a20dc0a2de7d942c2217bd44d762402dbbdece3dd3d1f5fce5"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c70a49e47a0a6825603764ecbe3667c6036d2e1b32a0580b27b10387f55d7370"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a926b0add9b13273b52cf5159448b61a1a1badd2cfe9a874f2314176f399bc4d"
    sha256 cellar: :any_skip_relocation, monterey:       "241cd647ee64d6aeb0930e1471e38db10ccf9f0c15d32ce43a7e12cf1b6af4e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "795d662151cee31b2e26f27fb946010caad270366515371d326cd2b852c6299d"
    sha256 cellar: :any_skip_relocation, catalina:       "16ca47eb88276fb0c8e1863330ecfa933f86cb543199be03d439ff7989c55f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc95dcec1de827877b3c705cb4ae77f544394bd0ef911c518328aa286e670a75"
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
