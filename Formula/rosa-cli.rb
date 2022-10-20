class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "d6e70db8760ac1a60bfe2e3db3759d8e48e4855d7779674fd6c16bf5f460dab5"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1805f114aa6d396ef9813b120a2231f4c173fb3aff0da02d1d32555f963ddde5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7fc138a56cdf89b68f2a161130916ae457243079b1a7b6814bd18b9a76e1216"
    sha256 cellar: :any_skip_relocation, monterey:       "6202a3cb267dc952b42af16cf4ee3c148cea582fe5ef6d122be3448682b51c70"
    sha256 cellar: :any_skip_relocation, big_sur:        "c202759811b77c1e2a1d60a5e8218992804c8c11e5a2f7bf734b915d0b5260da"
    sha256 cellar: :any_skip_relocation, catalina:       "33433e6ca7f7ecd75401408dbce133e5fb685e7dcbe77a40e4d6520697181d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5519d16ae5ef922caa7b95e0d92a2df98c0ceeafbea97a4c9a392a16ccb5eb71"
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
