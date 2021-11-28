class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "2b27225a9bd56279b851004a83575ba02d39ec8193dffe7e47183250cdf77df3"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c485ebd9b235878d412ec2de12f3e7cfa1ff4536b39c32711ea050fc282e9d4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc55aace4723368b0811f1bca9939a5df2b41085d31daba1c4cc3d9e0a3dd141"
    sha256 cellar: :any_skip_relocation, monterey:       "8bdc0b8d5a787a29f06246178adb48d8a927140f71d6476d46bb393f445e07fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e43f7be1fc20a55f8b2ac70f42d28d44d3fff4bc7bc4b421d33e3a69c3607ef"
    sha256 cellar: :any_skip_relocation, catalina:       "6572d21999a1de7453c0bf7b5a0decd72c662d8cde6905e85d67b02b025647bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8d1018f7581a6bf9c31da467c890d287d1c885b367aacd8f5e629eb48818f70"
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
