class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.74.0.tar.gz"
  sha256 "04268af574690b84bc3474a5f19e002cd6da3e16899fac9fd39c6e84e7843940"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2d5390bfd71240ba47eb2ef480d95b172d7379ff2a7d7c74024efa44ecad4b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dac4c732a6accc32250b680c47c84a4f5c66bed80405c0ccc30526586581d080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0163b35fb42cca43a4b1bd813ed0138d10e91a5942e20fa0d7d2489f2ed3c5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "94ef7d1e238b3f48415445be41799b5e229495e57192665fdf569e09f82d38c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7db8a5e8c1cadbc46fead3c842d3bcdcd883c4d0013c9a61febdd20239721ebd"
    sha256 cellar: :any,                 x86_64_linux:  "3ff0409831540fa6fdb8208be7bfb2e4d5acd45cdba93849e815bfd8242d9322"
  end

  depends_on "go" => :build

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[-X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}]
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
