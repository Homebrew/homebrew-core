class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.58.2.tar.gz"
  sha256 "a1fb22566a476e963b9c515c7fc9d57d52411cea56f5c1f424817c8e232964af"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82ffdb9fe2657c9142742026f6a9591f029ea3aab1f8b0b2f2412f2cf54dbeff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aae467074c02a10c7c0d0675723bc42990bad8fde34e95f1550a1056cf48ec8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0337f08798605ed2d7b60ac5b82e8fe083d04448f78a3ea2503d973857d6085d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a250b35c213e95d175a89038094cd5cd6f8aed40d70bb1ebb3552a80c16a9ff"
    sha256 cellar: :any_skip_relocation, ventura:       "9c60cc2cf47304dc463c14eabef19a97af6210a5e4c5b68bc4d0fb253fc393cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84168191a68cb0639ad0b91c523cef943081257d4e2c7fb9f281bcfcf8439754"
  end

  depends_on "go" => :build

  def install
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
