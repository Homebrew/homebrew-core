class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.6.0",
      revision: "2cbf5afd5460b51fd40939f8c44b32543b1a0bcb"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b3fb2b027e8d33795dcf809528e5fbeab53ae755dd81cf34ddad793f37b7b61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05371bfaa632d2db02014dc850d2fe6365edb885cbbb305cd228175c4c9934e9"
    sha256 cellar: :any_skip_relocation, monterey:       "c754205e12826d6088dcc148e6c6436f676c7d15266ac9266e776fa66d7a3d37"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4360615a430e58b19e16621be13d7494f241c8b3dbbf3d3daffaa555d84a429"
    sha256 cellar: :any_skip_relocation, catalina:       "fdd8efe3e7a9bc361c458517de65efe9ef7a356877ffbae6f4ab84ebe8b61733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d140bda24bc13a5b003be0033e6a42c3b92019dbb602ecea29ab65498f6ce6c8"
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
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 1)
    expected_output = "InitRepo: repo unreachable: GET https://api.github.com/repos/google/oss-fuzz: 401"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version 2>&1")
  end
end
