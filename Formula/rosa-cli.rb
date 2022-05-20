class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "913079f2c184b2f244e764be8a35c27d356982b3058bd7f21b6af95f5f11bb99"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43b54cded5c55e76673aaea0565d2bcd968d72d2ba75e7340428436269aaf8b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59b4e0dc5c93b6754a7da9b5f61ca081a2ddb554b6e0283064cf4056eb179484"
    sha256 cellar: :any_skip_relocation, monterey:       "0dad1fa99c7a44d35641a67de89b13eea4aab9bf3b05ccc0e051c97b5913b032"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f96ff3a2331db26e8d8f01232036898a331d73a5bfbf31becc9b4ca3d4eb84a"
    sha256 cellar: :any_skip_relocation, catalina:       "7d997f72aab1acb816c625246b3ba51446c0d6c25f1654a2ec36da59d9adcc1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e1a2c4b661bb80bd5a8b37a9c35757cab860e549d6a8dbc1edc2db96454c2ff"
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
