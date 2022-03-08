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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db4d707ada907217494e7e85cbcd7b6a6cb8fb9c86556ab07e602f68c006d192"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "270dced721a64bf28c0d0ba049f9df104e06d106761f293b4a51768f6f9d4377"
    sha256 cellar: :any_skip_relocation, monterey:       "d4bab508f7eb6d51049642994047478eafcdb27cbf6b330cb374e05fe444ada7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8221d876e0f9e30d712e4cdf97e8abb3d58138945aabe8e7b6107909ecc59dc5"
    sha256 cellar: :any_skip_relocation, catalina:       "48e695755676b8f9bfd32e76ceb586c357e2106f969d893b9e95cceba6f58eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53fedb8aae59c610b06a7a57c584993a165d54eb64bad75c028b067496928115"
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
