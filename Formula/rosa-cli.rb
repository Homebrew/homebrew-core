class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "5a42e93903ba553cdac6cc978a918f903f46cb63be7aaea82ae9a315ea13a23c"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "337796c684c76ae120c94ea37e0625825afbd2e00ecc396189827fa00bb1a9d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "aae37624ab2ac396f1fa448af5d2444a2c42d5fc9accd4cf70088fee949da51a"
    sha256 cellar: :any_skip_relocation, catalina:      "de19e2ac01291f7376a35652b3f0f3a20c449eb5956c414eaca929a81c89206e"
    sha256 cellar: :any_skip_relocation, mojave:        "1168434b6c283d9e8a48ed38c53c325d4d27cae5f73a47df2bb9c604d2a0460a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "100c41e65be701c189cd73b6b589b860c9d24b34e4cff5a6c9561ed416504f4f"
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
