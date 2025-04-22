class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v5.1.1",
      revision: "cd152cb6742c5b8f2f3d2b5193b41d9c50905198"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce30de52c69e14aebfafa7b3e444f535d23086698c7957bc2d485fe8574af53b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce30de52c69e14aebfafa7b3e444f535d23086698c7957bc2d485fe8574af53b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce30de52c69e14aebfafa7b3e444f535d23086698c7957bc2d485fe8574af53b"
    sha256 cellar: :any_skip_relocation, sonoma:        "01c5ef2f4c26bfa9871482b527bc3b76bbeee8168abf3938065d7a8f1f9d999c"
    sha256 cellar: :any_skip_relocation, ventura:       "01c5ef2f4c26bfa9871482b527bc3b76bbeee8168abf3938065d7a8f1f9d999c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bd114bbac21e5885bccbdf061621b332879b1fd478b88c8e04d98c55691cc1d"
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
