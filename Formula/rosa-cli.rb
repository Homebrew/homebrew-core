class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "dacf844b16ee968d64148292604c808c4017e3c94687d1753916a416492b8898"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7ed25d384e66f7281ae425bb336156306ebb0e09234443bdbdd89b0029bb7c5"
    sha256 cellar: :any_skip_relocation, big_sur:       "60cccb7b551f06c6b59b97ab41fae87a9b56b95c1109f89e322321dd11ac08c4"
    sha256 cellar: :any_skip_relocation, catalina:      "f640ae816ea40493c135f1dd0322468462feda162fff101cd6e963a1302cd8ae"
    sha256 cellar: :any_skip_relocation, mojave:        "4953aa544cf6097e4639d08c8297d81086085ee3b5797b54eb2ad1fa09799ddd"
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
