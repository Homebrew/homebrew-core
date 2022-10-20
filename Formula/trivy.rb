class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.32.1.tar.gz"
  sha256 "9a51965dd430fb3d23aa72aff9dcf8538704aaadbf4c3d4acb4f017c1f8fea01"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b02b9071d847176e8b93f5131f01b6bbb24e62bd39dd5c0346ce4327fdf955aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f1aa39971f0518aca53651801925783b7407aca7a8811ad8f429035b19d5baf"
    sha256 cellar: :any_skip_relocation, monterey:       "05c01edbe4afe3d5270a0f1d0366f93eb9357a9c10a9b4c16b45f9c5970bbe18"
    sha256 cellar: :any_skip_relocation, big_sur:        "fef8b19c461f4e4ee10877e8c5ec62486cf3bf4ccb66882b83239afc9833b8c9"
    sha256 cellar: :any_skip_relocation, catalina:       "8ef20530be9b8abc78d2d16adde042b4e9bb842f639a6b8d6692f8f7f01580bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aa7cb61b416765d09344360d250528e4c64377d7fe260a13b6be8bd50bc526e"
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
