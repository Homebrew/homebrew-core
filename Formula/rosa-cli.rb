class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.12.tar.gz"
  sha256 "d84c588e1a8f355745b063729305a0ae1f8fa1dc24183ec1b0b5acf62cf4964b"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39d235a20314598ecb75f1d3e22abf0834529c33886ed9f0067faf2d56051953"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "981ebba8a96cccfe1a4d6e317085bf94dc1c15677c8f1170dfe65685db0f944d"
    sha256 cellar: :any_skip_relocation, monterey:       "91e54ce583f29ed2365ba22f903c9ebde571271e4bf722ace2c09724c6ca0e01"
    sha256 cellar: :any_skip_relocation, big_sur:        "ade9340f2bd2c873bf074423813707161374a596ccdef0ca53c1838f4656c4e6"
    sha256 cellar: :any_skip_relocation, catalina:       "43fbe5aaa8673e5e774313bde2b86f5cccfc45510f541bf53274d7eb6c64b846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6680ecfa006d941d86bed812a39dac36a104a9c637b2d7464fc71a972f67b959"
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
