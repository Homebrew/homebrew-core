class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "229b342e0767a9594f8c9e07c2792999c84627e2ef7ecdae5b0a21869ece2f8c"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "637bc63a9a87158cb43069330b9df3b175b60bb0c9afbc1a7ad1deb24e29fd6f"
    sha256 cellar: :any_skip_relocation, big_sur:       "d91d264307b1ab814bd4deb5ed34a13999420d859288d3a9e88fdfc6362a7f8a"
    sha256 cellar: :any_skip_relocation, catalina:      "02978ca867911741f210a58d6a518eaa443ae0b4c7776165dfd31b062b254d3e"
    sha256 cellar: :any_skip_relocation, mojave:        "1c77eb6e2ce4d27fbe09dafbf6e2d5cbedb79cd8420b1cf40c300202ed055825"
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
