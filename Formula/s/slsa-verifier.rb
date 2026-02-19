class SlsaVerifier < Formula
  desc "Verify provenance from SLSA compliant builders"
  homepage "https://github.com/slsa-framework/slsa-verifier"
  url "https://github.com/slsa-framework/slsa-verifier/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "19af322eb0ae0cb738f8e2395b3dcff756537277d62688fc9d2b4fc5ad6b16e4"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74a05f9a862de1e4b5ff0c5ec8a276684dddb282196ecb13010941960049274f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74a05f9a862de1e4b5ff0c5ec8a276684dddb282196ecb13010941960049274f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74a05f9a862de1e4b5ff0c5ec8a276684dddb282196ecb13010941960049274f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6af212bf84e8c9a121278554c084c8316cd360ecf3a29cbe0d9918b256e3f1dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f211fb47549850522eb0187f98471eda17743dfc79c7572a6018aa282f141267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e588593813873d0d0c768d1e85c38db2e6e1871cc567950fd7a2e053b4706841"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cli/slsa-verifier"

    generate_completions_from_executable(bin/"slsa-verifier", shell_parameter_format: :cobra)
  end

  test do
    uri = "github.com/alpinelinux/docker-alpine"
    output = shell_output("#{bin}/slsa-verifier verify-image docker://alpine --source-uri=#{uri} 2>&1", 1)
    expected_output = "FAILED: SLSA verification failed: the image is mutable: 'docker://alpine'"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/slsa-verifier version")
  end
end
