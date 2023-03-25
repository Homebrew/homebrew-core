class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.10.5",
      revision: "27cfe92ed356fdb5a398c919ad480817ea907808"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac00790290a6611cd7759964ef30fb8c191a477df942888adefa3f8ca72ad075"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75fe8acee3f03745f43ba5fa7f62f4a4a722a956d149e8c28d9a42d7ed75a0f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1ed2b277256147bf83b59a10937bc275535159212d07c927442fb3009b5b951"
    sha256 cellar: :any_skip_relocation, ventura:        "538e909ff73c8fe2d404b945fc561f0e8900f88f796846d3a3581706b8dc33dc"
    sha256 cellar: :any_skip_relocation, monterey:       "6ac9e161ed0485e5cd69798ea63cb95db21ccf7555e79d22742c2e2521f7894d"
    sha256 cellar: :any_skip_relocation, big_sur:        "523611353625e1bf5acde28acf3abe089ef2666031b83cd978f2433d29c69c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "064e4a5d7219495bff7088c6bf67d1f46203b5e495c5fee9763cf8c177773a18"
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
