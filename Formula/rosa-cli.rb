class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "c1d02b5aae4c89a49d68001b11a9e99bf86b6a70b322c09c5d2f2b5549a484de"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "efe059fd4b151602d72a4630f692da795aae1c73c2dcf39f6334731efa342bd8"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a690ceaa903b2a334496af2706f7f4d26b0a747e2445127a04ae6a9a625530a"
    sha256 cellar: :any_skip_relocation, catalina:      "839aa5e95782a0cd2f2ccaf53c9b97b66d01df2d1e5bd3274c55af5ab4644a34"
    sha256 cellar: :any_skip_relocation, mojave:        "f9a6f061759528693734840fb31b59d8f1bf9b52a95def1ce78cf7f21789ee2f"
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
