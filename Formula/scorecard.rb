class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.11.0",
      revision: "4edb07802fdad892fa8d10f8fd47666b6ccc27c9"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb944a7610a3b88b84c4053e4f6f62d316ffedb64d0d7f0eef92187af02c42ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb944a7610a3b88b84c4053e4f6f62d316ffedb64d0d7f0eef92187af02c42ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb944a7610a3b88b84c4053e4f6f62d316ffedb64d0d7f0eef92187af02c42ca"
    sha256 cellar: :any_skip_relocation, ventura:        "ffdb4b64589f8b2a035afba3e2e3f6778bdbde814380f5696ab0b3f74602f061"
    sha256 cellar: :any_skip_relocation, monterey:       "ffdb4b64589f8b2a035afba3e2e3f6778bdbde814380f5696ab0b3f74602f061"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffdb4b64589f8b2a035afba3e2e3f6778bdbde814380f5696ab0b3f74602f061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c25d27653f6a49e95551e7518eb0e1d31a026ddb413304dc2dd9bc4184c0192b"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "make", "generate-docs"
    doc.install "docs/checks.md"

    generate_completions_from_executable(bin/"scorecard", "completion")
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 1)
    expected_output = "Error: RunScorecard: repo unreachable: GET https://api.github.com/repos/kubernetes/kubernetes"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version 2>&1")
  end
end
