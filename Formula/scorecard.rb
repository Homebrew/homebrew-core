class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.8.0",
      revision: "c40859202d739b31fd060ac5b30d17326cd74275"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01b3f14d980a5c35a388ac305739135426709ace3ff8ae79676e084bafeff2df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ac2829027a056b4fd660c0ade94b1ce26f34f8d99bdf8850c81739325ea5d69"
    sha256 cellar: :any_skip_relocation, monterey:       "59a1cf1bbe9a4e3fe1fc66bfafba7ee205cf6e26bd3b5663ce9962806cb7353d"
    sha256 cellar: :any_skip_relocation, big_sur:        "983f70f41793c186febd3b9bfec30378dc3bd7d14fa970e22af1be38259277c6"
    sha256 cellar: :any_skip_relocation, catalina:       "ee16271fd5ae1537adea820d0add2f9dd54fe00cae18eec20804c8692e70dc4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f069900fe315e85b4ae53e31d822f61931b35e80f0198411347875f7e3ba2c1c"
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
