class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.7.0",
      revision: "7cd6406aef0b80a819402e631919293d5eb6adcf"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0f7a013705ff666b30598b636a4ad10eba106f07e434e2b23d45d3d8fed2edd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9a3fcd814d143e400e8cc474330be5ecf9cde7975ea35b594c796441483091b"
    sha256 cellar: :any_skip_relocation, monterey:       "0385255fb6e67034e95a7a6a058a5eb5b0b048d9736c7c8a00f6c3b5544a905c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c9d6dcc263e019510b649027e44d2f761e2bf59a015f63ec7360891663716ee"
    sha256 cellar: :any_skip_relocation, catalina:       "bf522d0b929ef5d235a7c221f6bb5229d15f734621a0fdf4b41c81bd978e614e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81169cc67e05e77580db46221b01081cb8d8c8a4a56b1b6cdb86c616375b57af"
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
