class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.17.tar.gz"
  sha256 "0c5afa243566013c9cece39d5e332502f258ad4c3d611b5d7e3ee06fe00db46f"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae10bc44c62edd865dffc64a77771268424bbfaca6e9ea0a13b366f0193dd3e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae10bc44c62edd865dffc64a77771268424bbfaca6e9ea0a13b366f0193dd3e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae10bc44c62edd865dffc64a77771268424bbfaca6e9ea0a13b366f0193dd3e3"
    sha256 cellar: :any_skip_relocation, ventura:        "5ec77603eaa8552a93acb169669fa89461cba89c8401a1f8130d4b648ee89dbf"
    sha256 cellar: :any_skip_relocation, monterey:       "5ec77603eaa8552a93acb169669fa89461cba89c8401a1f8130d4b648ee89dbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ec77603eaa8552a93acb169669fa89461cba89c8401a1f8130d4b648ee89dbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5241d03ee9d4103aedfaf8535e45d4df4995baeec7afc60f3777fc7640f30536"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Failed to create AWS client: Failed to find credentials.",
                 shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
