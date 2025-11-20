class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.67.2.tar.gz"
  sha256 "280ff8cfb17d05d6b4d1b07bdd3cd26971032301bedb3b800a14886e64ce75eb"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e4550b452792c7ca30d2ed141ecd202ef113bcffd2f52e79e943bed1c48b9bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daa85678f139297e0ec1249403372aa59ab2e8593890e9134649a2bfae75e931"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf5ddffdadebb255c7ba54462bffd33f6f0e052ea6d299f88eb57b4931126b51"
    sha256 cellar: :any_skip_relocation, sonoma:        "10e5532199afb1b19840e3d1fca95f6bedcca5d001d6bb2877f220643cf01cd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5001081ee01f4f9487e9d12913c413443b4ad9edc184b6b12643c901e706c9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc75dd8d6a957b1ad25f50e072c39f4d7a377219e183e4198c8edcfc86c201a4"
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

    generate_completions_from_executable(bin/"trivy", "completion")
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
