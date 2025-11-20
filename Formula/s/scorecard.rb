class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v5.4.0",
      revision: "80ee3ecfedf8b19ab8991713a9fdb2e7dcd7262e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbba38cdcacc8ec86d7c4487595614bde0e362247163910350ade8a5c5772891"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c8dab295791bc9b4619c483dc4eee68a7f1a84d25226fb8a830b9195b723795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d2eb2e46c96207434e7bb23a4af49a08440c4269c5a6d0f6255b30d82ebd973"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dea58448953f2e63497f045a0bc96e81c2823971e2e5d240abcd41e2a18f898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f200038ea24d9fa0b87974bd7fa5921f2bd885bdde86a59ef56e154e96ef1d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34118febe45d6da739aef5cbfcca5e4c0d9b8065ed626919a116755b42f6fdb1"
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
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1")
    expected_output = "repo unreachable: GET https://api.github.com/repos/kubernetes/kubernetes"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version")
  end
end
