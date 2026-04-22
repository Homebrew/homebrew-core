class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "ff9ac06468aab89802388f16d1d179f4680db714afbf6a8132a417d288aa008e"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "849fa08e89fb98fb9acd8fdf3a7039a2dc0290c0b560b2c944ca44f7d1bf11a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a52885984006333d0784e253ea64326c627d9e8b8b80b894e5107519c03c681f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "260f6aa3a38dfeff3939111b04ff7b814fff5f8af2c72923857de9bec698c4b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "263cacd934b02877b9764b59f8f4eb448c7cd84c70a7ea02e507a080a456f254"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d3072ea47b493f28013354e7358fafb926f34c1d7fd3423462c916133c9cf9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "142cb02e772528e127d7aceddac052fe4c8c3f52d3a74c671c19f01c8ea588c1"
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
