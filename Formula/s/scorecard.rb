class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v5.0.0",
      revision: "ea7e27ed41b76ab879c862fa0ca4cc9c61764ee4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d59b2ffe434e821e840026ee54b38b9aadf0e71ca8286d2a730fd865edb4b1f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb86a71e713ce93d7e08051667fe6a2197613047cbec9c64a8572cde81dd52d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07a542d4ff169374a9a9632999b98cfc7a48719f8786ccc9edea1cef5764c3ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41b86eb70666472ee47cc8ecfd8992db448f7a09e73672602a1b65ae112086b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b44cf7c5e4dc5f26320b8769e58358516781f90df2a74503ea0453d60ff2c9a8"
    sha256 cellar: :any_skip_relocation, ventura:        "d079166c946f21c698181d8f67fae1ca10272016ed6826af59dc1d040ec4d289"
    sha256 cellar: :any_skip_relocation, monterey:       "58bab6f132516776dcffcc3ed3c759ecbf8d842f804f4c39c8d8a6967004684e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db84f0cc7eef86a728048c8f5f31273e84e5b9f57331284444ba94e290c522ae"
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
