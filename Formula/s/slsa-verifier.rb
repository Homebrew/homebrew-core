class SlsaVerifier < Formula
  desc "Verify provenance from SLSA compliant builders"
  homepage "https://github.com/slsa-framework/slsa-verifier"
  url "https://github.com/slsa-framework/slsa-verifier/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "5f8087e6eda61482e928ce209e550d345ee6ce7667dada42cd83a0437065b82e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "df827e49081b703823cbbccb01252d3445101ae7390a4878ad1ea47c212fdcce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce4b7dda9cf008548c59673522d450c473d1feb47f124a3fb0f076c31b4cc588"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7e1a021819162cd3cbe24766bc896052bf3152962e225f8281ef13bdb03c2f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5de731335d288f870a0bc7234a1863ff0289548d269e8763bc554ff0ea5ff013"
    sha256 cellar: :any_skip_relocation, sonoma:         "6033c9e1b3ca86c150fff5624cd4daa46ae6af4405438a79ba91747310d528be"
    sha256 cellar: :any_skip_relocation, ventura:        "fd0043c341b5ec63d1c055702fe1ed11b772dd81122f5121695475717e178e27"
    sha256 cellar: :any_skip_relocation, monterey:       "94906edb8bb402a2dc60dd946a2c8392caf260746c2482f3e442137871a47c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7ee0e2b74abf16b0a9455f360537208064f5e6824c07736cfec07de82d84447"
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
