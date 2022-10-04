class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "1cf2615107659d449c988fb3163332854551bc99b2aedbecc12517b5a936854b"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4be0500a84772c4c22365e1abf4042e94afc42fcf0d8959ab93a2d12fe16864d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4ad22aaf98a424114888e173974094e3346de03c182cd7671d98b71ef8fcd79"
    sha256 cellar: :any_skip_relocation, monterey:       "8ee37c40faecb10db1c54269e32850f970835768ddfccc46a883710fb71c532e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e46900b76efa9f5327e2483e16d3ab1fe2d114824c5bf7c858cc02e71a9e2357"
    sha256 cellar: :any_skip_relocation, catalina:       "0be6bcf8add578e4def595ffbf459841e518ccf1590d7de51a65c5faf0bb0944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f0f3a3514134814ef193f44a3ce2986000ce7e489c8c5e48e8db0032cbc2838"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Not logged in, run the 'rosa login' command", shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
