class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "88dbfcc85dcca84dd94a9e84dac8f94fe779a99d8249b975d9e4cdba653497bf"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffdb04f4694290f3a76918c53cd1cdea78cc9e52b30246400d5e9806bf7b708d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec1a81c6291bfa70a768e14b72e8ae56cf865d599cfe16f0a25bbd571503e1e9"
    sha256 cellar: :any_skip_relocation, monterey:       "598bcb3abead9d45a082087429e8e4589803ea828e8df200004dac7224bc1e55"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfb14733e35631092c37dee361c5ef4a6c0b5c0d440b00f16d1fbc767e43af00"
    sha256 cellar: :any_skip_relocation, catalina:       "66cc11e3788951ae1fd19af000b04c13b0706a63fdf182777e0cd3b8dd760f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b3e389e7bde3b7f85abdb11aaa4e85ff21b137611000db4bd1122f1194101bc"
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
