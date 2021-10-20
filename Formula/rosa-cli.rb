class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "286784a3a5ed5c7ab18ee983e64c40bd58946214154971266ed4bac3c16c67df"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff3ed8c5bdb9c2ca289f067ce1ad5ca9e24345c7f5fd3dec540e3d63424ac14a"
    sha256 cellar: :any_skip_relocation, big_sur:       "fcb47b8081732e0399f7f7842f959cd3b8aa0fe1933f27c31a63497a137473ab"
    sha256 cellar: :any_skip_relocation, catalina:      "30ddb37367fd24f9f41a64c36938289edcd9126e6505f6623c614fd3c147517e"
    sha256 cellar: :any_skip_relocation, mojave:        "15dd53e743fee578dfd6c7a00ae022e69b35b824f3dc3eff66a00a29101e39a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9528ad1a6d647f47e40496c6c38ce205e0c82aa9b66284ba638f24f14c091dbc"
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
