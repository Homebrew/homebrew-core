class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "8bf81ca69d57f2f2c21cc385cdcb49ccdb92ca276c4930ee31e9da0a9ece1823"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a19ecdf3227e106d2bfbcaa9e30e3542b3b2f9e76d633be8456a404c8392a604"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10f080608e8a1a87ab780352263fb4d5072ee3b8156b3789ebde711cb707bdcc"
    sha256 cellar: :any_skip_relocation, monterey:       "a18a56f3ba726f0018ad70aa0d384a5442c37611d33ea9dd0b1404934d099668"
    sha256 cellar: :any_skip_relocation, big_sur:        "493037297df60ef504232ef090b3ce20a260434d4725772ba6b988e9e7cf6a29"
    sha256 cellar: :any_skip_relocation, catalina:       "7f5ce18c15a8f3f15d424bebce0544e0b224a627460f3b09d59a1f78b01ac380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8295c4381200cbfb3f8afc3642f984d6ddbb8e03db5aad8630ffdf521bd88e73"
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
