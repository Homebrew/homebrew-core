class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.4.0",
      revision: "e42af756609b2cde6d757fd45ea05ddf0016ff62"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f82fd3def94de894b1299c81c0b8aa81e91dc3bebbd8df9e7f1dd268522b875"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a0d0aefe56a191e453d813606dc4b82407f45b5fb4ae76677d383d5ea64f4ea"
    sha256 cellar: :any_skip_relocation, monterey:       "d20da08deebd8104ff66b66d233487fa01acd69b304dc114b06fb9654c782172"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6df2a091e433ca3c83530a42ade527c833d40fb7524512e6954cb29f6ddaa02"
    sha256 cellar: :any_skip_relocation, catalina:       "d710495c255fdf6e21d1e28ec5656362a58abd8568e43a9deceb4386e1a7d196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "578324961d1ca4d30ac2a0b5295326fe204340158ce4f0e26b07fb15b0ac1164"
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
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 2)
    expected_output = "InitRepo: repo unreachable: GET https://api.github.com/repos/google/oss-fuzz: 401"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version 2>&1")
  end
end
