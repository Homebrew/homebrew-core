class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "cc27ba8a4b82bc88d97955e21648592dd29d586802629603f75e1b2fb35e35ba"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5dcec3f86d9979a562273df74cbe65e545ec1b70dfe83a51f4bf54268cca0139"
    sha256 cellar: :any_skip_relocation, big_sur:       "182b8a52f2aa47cf39aab4b6382e95392d7d66c1f8d88ac6cebc50c60f91a9ae"
    sha256 cellar: :any_skip_relocation, catalina:      "c2d0edcb46b67d64662b058b7c9638c003e56988192772b02d7f8c9c7f2625b7"
    sha256 cellar: :any_skip_relocation, mojave:        "6a67b7ecb48c0b0e806d2d1249e69143448ca97f7f426779508f386df63d364b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6260306bb676cdcd95d46c567376a75e6c344ab31b1fd58154f263568e1b0e5"
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
