class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "06a034bc17f8e64317c37cc9ed1afabee1fa99c4838f071e58322a22af59a64e"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "039abea7239f18a07db3cf86bf22232d37ca3a63b0803330198110f0a1d0f174"
    sha256 cellar: :any_skip_relocation, big_sur:       "db1f8f387ce620f8ef45f437fd04b2a7bf57eaa64ef6123959ce30b349a573f2"
    sha256 cellar: :any_skip_relocation, catalina:      "c29d121064a125671d61450e7a297da3c56620a1b7fb4b1ab2c2409380ded133"
    sha256 cellar: :any_skip_relocation, mojave:        "48cb025288386e887a1f6f31944bfce43caf2fd95a279bb542525c772cb24d44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f6004cc281d4bdd78dc7c873b7b0ca710ca0e350c0d2878257a578f59e212bd"
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
