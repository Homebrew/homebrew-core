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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a8c678701d01455e37834825e97e5653c1ed55c131798271374d185e7124523b"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3078b9b539cdd15cf752b41e531ce6294820764d98f191e3b42aedfe4b6f6ee"
    sha256 cellar: :any_skip_relocation, catalina:      "90f6907318724ca1b7e5e62ce3c857df811c85d79086efbaca12a66cae668513"
    sha256 cellar: :any_skip_relocation, mojave:        "51cf1246dfddbf42516676b40eec810165f15574ecb6d585d62adab52f0a2994"
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
