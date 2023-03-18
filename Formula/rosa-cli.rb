class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.15.tar.gz"
  sha256 "d9e10c7f4a56c91d14d21a7c8f7a1c62dba4fc02321f28b6b66b2926f89aa528"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5f95a6f5fdeae03d9f53f57fe24fc4d36661b1862063853aba4b7580ed60b07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5f95a6f5fdeae03d9f53f57fe24fc4d36661b1862063853aba4b7580ed60b07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5f95a6f5fdeae03d9f53f57fe24fc4d36661b1862063853aba4b7580ed60b07"
    sha256 cellar: :any_skip_relocation, ventura:        "797103b2a26f33c19982a64e730b189eb50ca056b28644aa30b7357b3bc7e9d3"
    sha256 cellar: :any_skip_relocation, monterey:       "797103b2a26f33c19982a64e730b189eb50ca056b28644aa30b7357b3bc7e9d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "797103b2a26f33c19982a64e730b189eb50ca056b28644aa30b7357b3bc7e9d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24bf3122ed95c3c5a561be9674a306949a74dd038ad02ae46e3d15937d738ee2"
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
