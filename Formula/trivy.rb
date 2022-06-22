class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.29.2.tar.gz"
  sha256 "df82e986e05032f9b08bc9b35eea0926f312ed7c839c6eb9ea6553c482e4f988"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "383e26a670eb564e4a58f37f50836fa2c1e72139b1f5280e3151af92233d4858"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5aa008779545926dbca756d96b3039a2daf84f3d99c978b463416df0e248cf3"
    sha256 cellar: :any_skip_relocation, monterey:       "04a230934cd3ca67390f8ab81351704336bcf6a295ccf715275792ad34a9b501"
    sha256 cellar: :any_skip_relocation, big_sur:        "be26f8ff0c9b96f8698bd43a26c69239b91981a1cd74d1fb87337885b9883239"
    sha256 cellar: :any_skip_relocation, catalina:       "86fe1f098a5a02460e3a6e8bb99c332218c928cde9c8fa0047c5ca01b57f0427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8c4714ccca4d3f5d158c8a3774c489a16ec5da6336083a2d820c1c372aab9a2"
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
