class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.10.5",
      revision: "27cfe92ed356fdb5a398c919ad480817ea907808"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9db798b45c5c8bba34c518d9ad43c3250a74f98af8d7c8adbcb6111ef9df6fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc86c5f98c7bcfd3ccd9b5b93ad304a824f2588fbcff23a15e14e96d6604c9d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9f80e4132412bd10efdc5e02f1712a3b5a3d5e0a76a98658e7315793a10d2e7"
    sha256 cellar: :any_skip_relocation, ventura:        "991757bc14e288f6fc3069aad39ef277325863d6277335bd0367c7e15087eef3"
    sha256 cellar: :any_skip_relocation, monterey:       "d56454b8933858690c500ce3870f3d92dbf88c8966d6e1e5e1b346352644e325"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c38a224df59bf76f2a3d24e7b580d06ff6600fa3553c2d3c5cafbc7b3814c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0bcf936fe1fe6cf1258b570d65a4bffc855ba97311d9aa1e9736572d8845689"
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
