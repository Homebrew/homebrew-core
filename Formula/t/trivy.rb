class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "1708186df90a1981479d7273bc2f2468d6fcaa90c45eb9464b349c3a5f11c072"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22bb5364a03a1233853bb11eb2de3570104777fef7fc3156c35f31123a3e8809"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1edb101c342400303d9cb23c03b92721840b3debf46d5028961f8c9f87ba68a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aab02eb2ae0fd7bad3c04b62fb86241d287d7da050c3abfaa244cac1bac532ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "20c1f69868f1f8219101c3500396dc4de5c25fb01249f8dc3eb4179bb1ac2046"
    sha256 cellar: :any_skip_relocation, ventura:        "9a40d6278e0b86b27b898a4d0ac45e2ab7941ca470505d0a28ee6af3039029be"
    sha256 cellar: :any_skip_relocation, monterey:       "0bf4d6469d742dd10509be4b38e304f28efbf0a5241fbe56741d0f6141159d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a337f5d5c922d596e5c65e2fd1ec9e1d66ac6b81e2819920a3b16c5e4228ec51"
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
