class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.8.0",
      revision: "c40859202d739b31fd060ac5b30d17326cd74275"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "210754c5bab36169dab9b128bbc0e9130ab7d7df35edf5c8eb62fbb698578dd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6764bf06ef4952d1c93210f041227cc35899d29a86234db21ad706d3d6637360"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2340685e76caf448e95b451d47c275bfc834fdfdd2f2169406b948feb299aca0"
    sha256 cellar: :any_skip_relocation, monterey:       "82a8a427b524fd412290fb8047a75cfa4a7d5dabf4e2e6b274f790b20580e43d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dd3919fb6657b456b4a2bb20d4ca4f43729d424e4cc6ff0a35c7b5f2302b980"
    sha256 cellar: :any_skip_relocation, catalina:       "4e7f970c3057381cff75469f93ddeb4b0899eac5a5387b3e49d090ecec6a6466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91c269f768e4ac752ea21748ddfa44c492b7094a893015da6cdd91535ba3dfed"
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
    expected_output = "InitRepo: repo unreachable: GET https://api.github.com/repos/google/oss-fuzz: 401"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version 2>&1")
  end
end
