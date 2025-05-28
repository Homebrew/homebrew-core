class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v5.2.0",
      revision: "f08e8fbdb73dbde0533803fdbad3fd4186825314"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445b7cdaaa7d5d1567bdec012241f493f0145cd0b1ba94f40d08a41d373c34fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "445b7cdaaa7d5d1567bdec012241f493f0145cd0b1ba94f40d08a41d373c34fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "445b7cdaaa7d5d1567bdec012241f493f0145cd0b1ba94f40d08a41d373c34fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc468fb913cbb5acbb7d65ad0be9fc441db41ff8c13f9700e2cf863aefbb0ce5"
    sha256 cellar: :any_skip_relocation, ventura:       "bc468fb913cbb5acbb7d65ad0be9fc441db41ff8c13f9700e2cf863aefbb0ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb269329d5175ac8f27ab912e7d57ccae4f55d9b1ca7ab03a37a6e9f0a1d8266"
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
