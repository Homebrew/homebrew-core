class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "5aa0dd276e8e4811227277aa898953d40508832f54dfd6096d13b0d1cc48e523"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "555c510128c72712af1890adeb96e8a83d4af90dffd35d6057621918b976fdd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "116d41eb02b32f792b69be96bc88c18716805ee3e5d94cdaecee5e962fc4a9e1"
    sha256 cellar: :any_skip_relocation, monterey:       "059ddf7bc46161b8f8d70ac569e60ed31ed1e82ebdb6c320c9722da482439a44"
    sha256 cellar: :any_skip_relocation, big_sur:        "5adea5ef45e4dc410d9791965d19946cd9a9808e4dc99bba55956c84166f42b2"
    sha256 cellar: :any_skip_relocation, catalina:       "e92fda643f1b3cdd3d2cdbefca5221b65fa7807c54915ff84b5e17c5be9ad284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b080457ba029e3fe9346806bf240fe04499309026e14fe8b6c015243563f93c5"
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
