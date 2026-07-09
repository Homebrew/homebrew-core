class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "2c6e0e5a4b1b08241aab8e379155dfb31855a50cb1d04fa790039cf3010477cf"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b95b8565675066989ebf3a2d6b9d6e8eda998befc2140ccd0d8b31775b280bb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15539308e57d0ffde81ca030ad91e24477fb1a7265a2dd9c8a355319ea0c4f51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b0e44fda457bacbe70beca8de3a66cc2e687d9e7254ae664d533d8f6fb710aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "8112482f602d3b3ee05c0392dea082331312e5771db751b211dd1ef66a08fc42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fceac924050a79eaf620a5b438ce3d66d30ee2d1e025f47cb5ab274558540bb"
    sha256 cellar: :any,                 x86_64_linux:  "f60d8a51410801354c94a18dd7d00f65f17967a9e574392a891acdec8279a0ce"
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
