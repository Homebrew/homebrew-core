class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "ce1e739e5f80319cc9d65dfaf8d02b55ebe178e728de2abd6e400eed07cee1cf"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "491a3e038387651dbf37f6e0f3853ef98000a606032d748e206a1d03d06c2f16"
    sha256 cellar: :any_skip_relocation, big_sur:       "522cea288d30fe29f0d6742178b8d16535216607c71afe3b02ff9615b6d54fd8"
    sha256 cellar: :any_skip_relocation, catalina:      "acca0895d84e1cd534ec6ee2ce9c2f28473c605cbe7bfe6b1455df11b8ab3bdc"
    sha256 cellar: :any_skip_relocation, mojave:        "8c689bb98d089df7d2c3988e7ee42970e2a086eccab90267305bbafe7ea6b316"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args, "-o", bin/"rosa", "./cmd/rosa"
    (bash_completion/"rosa").write Utils.safe_popen_read("#{bin}/rosa", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Not logged in, run the 'rosa login' command", shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
