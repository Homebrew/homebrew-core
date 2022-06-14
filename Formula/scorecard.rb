class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.4.0",
      revision: "e42af756609b2cde6d757fd45ea05ddf0016ff62"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cbe5c4297032970e5d1af7c6b389ddc606b767de8f6a908b7a45421da72804c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e892a194b93aa4551d196cb420c68e0c7b6d4708cf00f3837287e0534f09c44"
    sha256 cellar: :any_skip_relocation, monterey:       "45fc4396ad7422ef0f7a639d7d7ad44c57f5bac3d25499382d26e050eded3a2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dbb5051e0cfef99560d6e6ebf4a2654ea796e7f49df7b3c495f3b738295df2b"
    sha256 cellar: :any_skip_relocation, catalina:       "0d2229204e9c9b9261b7e042446172db3c1f356c78c070e69b96d2809200fad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b49c5912fb6e81bc14276a040e583dbb3f44ff55b61cd566474963075953223"
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
