class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.8.0",
      revision: "c40859202d739b31fd060ac5b30d17326cd74275"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cfdb4a217d2d3142cce0153e29172604bcae3b5796623211534632064c42189"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64d54a4a5f77e7e95a306145283bd514fcc90dc5ac925bca0b6714dfa02a2d71"
    sha256 cellar: :any_skip_relocation, monterey:       "895544a110413ebc94898700535944bda0d8a32dd9de39c732e1ef2e99daba9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "96d1a0be347b86d87af8f533e95c61fea8ba2c939933ce3216ecb7c6b27f44a1"
    sha256 cellar: :any_skip_relocation, catalina:       "0d6f412cdad7b80d9719f547f9675f195121aa458690eb7ee5a7b38b1953dfb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cfe12467bd50fbc62c9881ae7c4d31531f7ae1f666736a46945ff444f2fa744"
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
