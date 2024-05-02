class SlsaVerifier < Formula
  desc "Verify provenance from SLSA compliant builders"
  homepage "https://github.com/slsa-framework/slsa-verifier"
  url "https://github.com/slsa-framework/slsa-verifier/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "2d01769e50d5769c803c15c35908dc1f6909dd07bfa76f0def81adab04a2a433"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4a47ce3376ebf07c792012924d7a0020b0058ac33b2d76284a6f1bb144b5b4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea0134e60f27369c25ab3f99e809f645bec9d2c9c309d6d47f92c75e20165160"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b47d399b3769d9ad47c877318be8a60ba02a69c8d4fb840537fe74e7e32c28cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "384e79d7a689f96cade0e789ac0ba4eeb1686e7eb86e58d0880259c6425fcc4a"
    sha256 cellar: :any_skip_relocation, ventura:        "04dbdae965da289a36159404eeb3876c54b880f880fd07bf074087d182a800b6"
    sha256 cellar: :any_skip_relocation, monterey:       "100f5429637d67b99d7cdbf0022570c1fd0d4d313c96ac6a78adad97f3aed910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6561209d63736d3909d188d10cdbeafef0166e0ae93a89449967cc7542c59eb"
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
