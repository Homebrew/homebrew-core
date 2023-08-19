class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.12.0",
      revision: "7ed886f1bd917d19cb9d6ce6c10e80e81fa31c39"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ccd33a9e999ed7773c5e2ffc6615bf1b676918d5f80a8e7fc70494361595084"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ccd33a9e999ed7773c5e2ffc6615bf1b676918d5f80a8e7fc70494361595084"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ccd33a9e999ed7773c5e2ffc6615bf1b676918d5f80a8e7fc70494361595084"
    sha256 cellar: :any_skip_relocation, ventura:        "34e3db8ff09f90839e79aaa1302bdc29b8c64f0844b1aee85154edf9059dfd44"
    sha256 cellar: :any_skip_relocation, monterey:       "34e3db8ff09f90839e79aaa1302bdc29b8c64f0844b1aee85154edf9059dfd44"
    sha256 cellar: :any_skip_relocation, big_sur:        "34e3db8ff09f90839e79aaa1302bdc29b8c64f0844b1aee85154edf9059dfd44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a487bcb8c4635292dd3ce937862690f518444026844790d890cbd3912e7a52fe"
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
