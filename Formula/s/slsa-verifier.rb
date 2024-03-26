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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "975e1854760e9ca124a7e7374f03b5d000a3ee8dbe6100965d9269cc3f1a1e0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecde6acfec216988e574ce374fe0c580b96699a3539d25a497d6b42d044909d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f950b178108ab59febfa53ef4b040e480c557b957855d2907e5970791517a277"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4a6d76256ddf33b89e98280b70e6e559353bde3650f6a19ac2a6200adbc3281"
    sha256 cellar: :any_skip_relocation, ventura:        "88028d14b515fc10ddd964156742b226f6b2b1f654998e03c94de80467dfa724"
    sha256 cellar: :any_skip_relocation, monterey:       "3dcbbf5f343b4bed93080329865754d101df568322d9c4adf91aea29d7d73ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aafaf9ae4d3f9895d247c435b954c85e1e8e384aed64f5a24ff87be8c4eed04"
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
