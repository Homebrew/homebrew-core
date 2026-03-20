class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.69.3.tar.gz"
  sha256 "3ca5fa62932273dd7eef3b6ec762625da42304ebb8f13e4be9fdd61545ca1773"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0d85c24e72327453868628991e3b8053b6dbb08e3c52bd29712d845e453f469"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2376e3929b5c080f5d6acc4ebd6f94cc52557afe1287c927f5d25178c46026a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa279a677b68b3dc1ce5e615c0de05d6a446d34314060e56e0e74901aa8d6425"
    sha256 cellar: :any_skip_relocation, sonoma:        "32a0cc6e2e2a1a5cb281383c6d87997f0728c7aa1abbee68dc33e7c1583b7ddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65772bde6ffadea570171fadf208786852ace51516e88649c4f0de1fc5d1e7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "729aa7df0d1f026ec18333fafc5f9a35547dc3f42a524bf83abc2017bb75833e"
  end

  depends_on "go" => :build

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
    (pkgshare/"templates").install Dir["contrib/*.tpl"]

    generate_completions_from_executable(bin/"trivy", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
