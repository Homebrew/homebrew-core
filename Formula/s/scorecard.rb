class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v5.2.1",
      revision: "ab2f6e92482462fe66246d9e32f642855a691dc1"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d7c8ecd2f3e9ae735e3c48c7984f1b48d32007a6faeb4c54319decb5042988f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d7c8ecd2f3e9ae735e3c48c7984f1b48d32007a6faeb4c54319decb5042988f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d7c8ecd2f3e9ae735e3c48c7984f1b48d32007a6faeb4c54319decb5042988f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e31a900dcff23bde75e4dd5677ec17d63c880424be1fb767921a74d2ccd5e21"
    sha256 cellar: :any_skip_relocation, ventura:       "3e31a900dcff23bde75e4dd5677ec17d63c880424be1fb767921a74d2ccd5e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "283d4f6eb3d27bd224130ced139af7a22fa4a0044eb72411e314a6e3ae7ea589"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState=clean
      -X #{pkg}.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "make", "generate-docs"
    doc.install "docs/checks.md"

    generate_completions_from_executable(bin/"scorecard", "completion")
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 1)
    expected_output = "Error: scorecard.Run: repo unreachable: GET https://api.github.com/repos/kubernetes/kubernetes"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version 2>&1")
  end
end
