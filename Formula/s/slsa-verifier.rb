class SlsaVerifier < Formula
  desc "Verify provenance from SLSA compliant builders"
  homepage "https://github.com/slsa-framework/slsa-verifier"
  url "https://github.com/slsa-framework/slsa-verifier/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "8588428d22f931b751dcdc7d9b0489e11840efe91c5074ec3fb84b9d4206a52f"
  license "Apache-2.0"
  head "https://github.com/slsa-framework/slsa-verifier.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d42a4343dbb0f18108faf80fa71f3a5a01ab9d67bc0134c104ac4b952b60de4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d75c507634ec7ffbb8f117ef1d37186f222b12760938a7fa225459a8468034dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f329c0aa0b2a8d7513040272bb07dc6a4168969016fc92581682044cda39b2ab"
    sha256 cellar: :any_skip_relocation, ventura:        "2ac447f426b4c461d5c3b857dc878a62932e3fb4c960a641d8bf314595d9aac4"
    sha256 cellar: :any_skip_relocation, monterey:       "b01c7c7b5d18701275e9358b96fef1921cd4b0a697119caa81acd8faa6256996"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a8680a86d01243fe13ddb6b3c73af02abe22dda9a1b543f0c48ce075cce9839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d430eb83cbaad15ea0929fcc1c4155b4e981e3246a690fdacabc8907bcb68b5"
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
