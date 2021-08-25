class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "506a8f7240a54821f7d42f827b7586555cc1ecfea5b85683b9c1db20a8329916"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bfb6f0332a68805bc4bd26cd392bef0034fab43308c26693a4301b41ff442163"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ffc85a344a8cd07501e102f0b3ca83bfe18f87ed6c18609e834eac6864ab461"
    sha256 cellar: :any_skip_relocation, catalina:      "e8b9650a21e9618c62f709dfb8d263c37b0895e3982072fd5f51ce015a4b41ab"
    sha256 cellar: :any_skip_relocation, mojave:        "717c6de3f0a1d27b2186f605ef474d2444197abcc05f344d3378bd7c96eb74c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b73dd557e93b9af2465a9af250ceb95d6d19f13b197f99c8bb7c052a7a0d535d"
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
