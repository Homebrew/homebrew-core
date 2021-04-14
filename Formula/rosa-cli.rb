class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "d734578190559d42f7484a0896f7d79a409b26fbc2abf0f292e277e5d1dd586a"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bab5a577bc86d7ed33a5fc42cbdde0e88bdf7c176a6ada455c4a1818bf23571a"
    sha256 cellar: :any_skip_relocation, big_sur:       "b360aa16941c1adbc160e8d5e9903fed0ab0036e2c2b376d481a5228dff2ee73"
    sha256 cellar: :any_skip_relocation, catalina:      "20c3d247cb3b6814cd31cab89d121527cea18da2f2be942064ab11125d8a6565"
    sha256 cellar: :any_skip_relocation, mojave:        "3be76554945b1b40220c5e5416f8b3d23a3ab3f9ea5127e06179cbef4bbda8e9"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args, "-o", bin/"rosa", "./cmd/rosa"
    (bash_completion/"rosa").write Utils.safe_popen_read("#{bin}/rosa", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Error creating AWS client", shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
