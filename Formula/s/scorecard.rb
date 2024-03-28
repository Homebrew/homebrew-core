class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.13.1",
      revision: "49c0eed3a423f00c872b5c3c9f1bbca9e8aae799"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3a907d222b902bea82bed05d34316c6af5bbb5c97ddb73dee3408f5a3f6cbe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f2854d392e107ee253003231eaa0486bb6802251e096f1a31592cfa5e70e98f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e6d5aea7da3b00deb97446cb8d60f1e6dd2e64a23d673ca1d204bff1ff9a96"
    sha256 cellar: :any_skip_relocation, sonoma:         "eeabe301b731c13418451abc53f9e2ad2b2e7e95f38fa19342699cfef4a272c5"
    sha256 cellar: :any_skip_relocation, ventura:        "2f79985dfc10e71cd22e30177a0e08fbd17a68ed546dcef4e86a7fa623a83d64"
    sha256 cellar: :any_skip_relocation, monterey:       "1be6d853e07335ed5d40f1c01c611dd18516cde871a735749128d3be49782ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec2a019b14f23682401f3b5b5138801919a53e43d29f2da86ff11166439f4a05"
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
    expected_output = "Error: RunScorecard: repo unreachable: GET https://api.github.com/repos/kubernetes/kubernetes"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version 2>&1")
  end
end
