class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.49.1.tar.gz"
  sha256 "30145d74a857e6d0a91bf585c295de7e8cd97d0a3233607a299a5c40069c48ef"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7535b4707a677a4b5cdb4bc5346534eeb274e8a05c31c504ddd6747fb8f9e1d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a068af34c37fdd9cc64a21698854407c76bfced3bff957656b49b3071369df8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92fa99468bbe4b24cf172a89191ceaf9b058ffbf2441de61c2cf98b05c3fc56e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a790490638b332cc6dd8784b9492d193d9838ea78e4414bf560a0f5bff7392f"
    sha256 cellar: :any_skip_relocation, ventura:        "a2a7341f7e0fee5231de52502bdc7af72c1d4d95edf66aadb77a0f9d4ecb17d4"
    sha256 cellar: :any_skip_relocation, monterey:       "3d3f93fab78a07be5f0236bca3800890c302e5d59902ae28faed3c7d0c1c01bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "792f1e73ce83fa8d8525bc7a8fc56df94bfa2920d9e687a45a4093dd747467cd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
