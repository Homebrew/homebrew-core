class SlsaVerifier < Formula
  desc "Verify provenance from SLSA compliant builders"
  homepage "https://github.com/slsa-framework/slsa-verifier"
  url "https://github.com/slsa-framework/slsa-verifier/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "56f4ef585269a49f5af42cf19f0683b1593ec57f516ff2d426cd81623d4ce6ec"
  license "Apache-2.0"
  head "https://github.com/slsa-framework/slsa-verifier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef2c9e94be3d84837f663d99d4a34cf01484823a8bfc05bd81c719b6433d1723"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef2c9e94be3d84837f663d99d4a34cf01484823a8bfc05bd81c719b6433d1723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef2c9e94be3d84837f663d99d4a34cf01484823a8bfc05bd81c719b6433d1723"
    sha256 cellar: :any_skip_relocation, ventura:        "6842d91f8a81df33035a444af23f65fe2149c42eedf58ef5fd115368d45f3fef"
    sha256 cellar: :any_skip_relocation, monterey:       "32806b0a61ab0028ad8f7864d29af5589e96be6e3d2086f8b246526d9a07acaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e46674e80decb52e1734444291bedbc989cda454975a42869426ba50d2c17a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eca13cc4e327e705e5dcc5109ee6588f3c839c82d8dbf08136daee7bc065e86"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cli/slsa-verifier"

    generate_completions_from_executable(bin/"slsa-verifier", "completion")
  end

  test do
    uri = "github.com/alpinelinux/docker-alpine"
    output = shell_output("#{bin}/slsa-verifier verify-image docker://alpine --source-uri=#{uri} 2>&1", 1)
    expected_output = "FAILED: SLSA verification failed: the image is mutable: 'docker://alpine'"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/slsa-verifier version 2>&1")
  end
end
