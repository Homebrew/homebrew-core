class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.10.tar.gz"
  sha256 "4cff9b1f08ab2e69de90f95d21b709684be85debfa108e3b56fed002a2787469"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af34316049454640c608859410ad6e54065ea729a431381a5624e8c2263a1d9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34b6960532d096e59651f64cf4bc765355714fd1a557c8ea2d2433c245b7d7d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1325969648a74c22ecf03c540f739c4191e111f64d78f42e2fadba1becd2656"
    sha256 cellar: :any_skip_relocation, ventura:        "bf8024dc782be95fc44413c60ebf1b4dc9eacab18d1364634c82b2c34c7a94a2"
    sha256 cellar: :any_skip_relocation, monterey:       "609e4a85a9ee1a22f5843162777c39d52dd70ea797412fea17226e1f0e23011d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cea1aad7cd699e5546365849d8ce85b23d9d4898f403f8fc0ab94d6fcf2910e"
    sha256 cellar: :any_skip_relocation, catalina:       "161bdba8b8a4140dd0c4b5128e66a2205ae74c97beeeeaaef062b20b1d4c429b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65ef7264fba453fce58ea748290cb5ddc4c2d7486ba98c63bbf508c4d1050470"
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
