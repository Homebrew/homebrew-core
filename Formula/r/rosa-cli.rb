class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.27.tar.gz"
  sha256 "c8e2619109a093082edf500d61d2605df39be5d66578583149cc28a1171eec73"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20bd1e0653d3b0c39c4cea64dcb685ca9e9e79dac1088d3b8b1eea0165a09f05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "243f3a994bf2187828b690d76c5ed4a75fcd1c695ee50c00e4eeeec54990d567"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e965edf2c6ccc9f6d46985a76d20708a6fc51351dbc6f4dd5798be01c92fe3c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d05d130a3be38d45bdd9d2aa1878e55d01050a9d7dc438d09bcec91b5c1de7d5"
    sha256 cellar: :any_skip_relocation, ventura:        "fc1f7be6c069fef3945c9038b3bceeb4c93b821517d03a59dc2cdad66dd6fd9c"
    sha256 cellar: :any_skip_relocation, monterey:       "9a758dd1e08582b3c7b5c72de2844d343a4cd874e6c593198cee1dec2d0b07c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0321f449e9a99e857f520c7185b4d6521d44c79d9a752c666e77e266a8c1fc2"
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
