class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "b0b7e2b9651ca27e760f151899f76a8080807d0cca0f97633b9c4a4c3efce01e"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7358bc013ede7dffbef62cec2e3d54b533e73f293396c68693e0bd89b3780dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "233bab086c52663aea3e6fefe209b55e5ab423d4c9c1eb361603a080addf6acb"
    sha256 cellar: :any_skip_relocation, monterey:       "c828d1ef0308b54eaba1fcdaa48550b9ab491abcb40e4edd9dc61939806e91b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "158971c061b9d33d3aecf8a1c230b8240ac051cf663a2656f3739c3965da954f"
    sha256 cellar: :any_skip_relocation, catalina:       "63c4a7c0fb6a320cc336b2bcb86f79f9d46d9f2a728dc4edf6f646f94f6aef7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0e9532eb0c7f948828867bdade92055e9116b28f246a4fdfecb4756ecc3e850"
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
