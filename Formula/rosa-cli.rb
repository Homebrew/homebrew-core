class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.11.tar.gz"
  sha256 "71c88a42088ffb091bedfd1396732805a49293c1632921bd05fe8785297a4bd0"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2b8574d0a1069f8de10cb046050d2d7f844233a0072225fcd45330325cbfe05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "518309d1f2666e3b05fd7026ab9f5a290ee295b1054eb40412d0b664d9ce15f4"
    sha256 cellar: :any_skip_relocation, monterey:       "c07d0411b5fe2318ba7e777ff779714a1852e3463c56fe067cbaddd1ada7f507"
    sha256 cellar: :any_skip_relocation, big_sur:        "71212fe11b30c01b0db8ecbe2657b9605d521c80d63295bb52c02db68c7b1f9d"
    sha256 cellar: :any_skip_relocation, catalina:       "72288b81f252441ccde950ce52855cbc0de65d6c83808e6d5d78bbe9b92002a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bed23c7139d3d2330130b51f86b940dc79c56140f5993900a70db8154ed2e730"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    (bash_completion/"rosa").write Utils.safe_popen_read("#{bin}/rosa", "completion", "bash")
    (zsh_completion/"_rosa").write Utils.safe_popen_read("#{bin}/rosa", "completion", "zsh")
    (fish_completion/"rosa.fish").write Utils.safe_popen_read("#{bin}/rosa", "completion", "fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Not logged in, run the 'rosa login' command", shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
