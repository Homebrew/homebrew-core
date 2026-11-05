class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.76.2.tar.gz"
  sha256 "ea2670e94696508b12687e1f8ac35a6fe529893e351b7e38362c4a385ff2db9a"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3d80e9b39e30f2cabca1604b8b23164384277eee5fdc917a4fc62223f2ddac7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bde1a16e0f58427aec8d44fabedd16dac07ced7c6df255e74afe32ca6db91353"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2eb159e9d050b64b98ac7087df9d5730d170f2ab4368cd9f7b45567922f9da86"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a1e419c153dc4c8ea7171a93899ff99c4d13e0f2f8f838f85bf324e431f6aea"
    sha256 cellar: :any,                 x86_64_linux:      "d739e1d5fd2c1e23d7ec57dcced2896b5a43481338ab6193d4ff1cdc3ea58e97"
  end

  depends_on "go" => :build

  # `test do` block downloads a container image and the vulnerability DB
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
