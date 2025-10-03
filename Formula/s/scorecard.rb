class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v5.3.0",
      revision: "c22063e786c11f9dd714d777a687ff7c4599b600"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "351c496a03c888ef7ff69146b9264e8f40a583dc16f23e105c3a0f17b685467e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "351c496a03c888ef7ff69146b9264e8f40a583dc16f23e105c3a0f17b685467e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "351c496a03c888ef7ff69146b9264e8f40a583dc16f23e105c3a0f17b685467e"
    sha256 cellar: :any_skip_relocation, sonoma:        "33bc563cc092decdd46e997eb9232535cb306efbac542a29509ade0aaa75ab9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48c59c9037ece6a45bf092e71ab9e75646f2e93df8f7bcc05a9e417be2e1e910"
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
