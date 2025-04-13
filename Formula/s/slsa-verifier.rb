class SlsaVerifier < Formula
  desc "Verify provenance from SLSA compliant builders"
  homepage "https://github.com/slsa-framework/slsa-verifier"
  url "https://github.com/slsa-framework/slsa-verifier/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "156190a6c96ef20747a88d28b69ee7fe60dc4d0fce3f9037da86778dcfdd2af8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aa2a807e3b7f681fe3a2202b0dbf80310dd26ec55275698354094db272d970b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aa2a807e3b7f681fe3a2202b0dbf80310dd26ec55275698354094db272d970b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2aa2a807e3b7f681fe3a2202b0dbf80310dd26ec55275698354094db272d970b"
    sha256 cellar: :any_skip_relocation, sonoma:        "106517b350402f5df5b7593cc10b501f878e1f244dd34a3db73f019846592e49"
    sha256 cellar: :any_skip_relocation, ventura:       "07fb4459305a82d44c6c128b1255f5a0a996d241f9c07432fd76f6e6ee4c74df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8794fbe8d5196f2e41227ec58833f905557f107199a2735f0ff6b4df7938dcb8"
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

    system "go", "build", *std_go_args(ldflags:), "./cli/slsa-verifier"

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
