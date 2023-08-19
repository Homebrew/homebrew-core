class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.25.tar.gz"
  sha256 "1a4163c1def0a5f803f3bb0331b8df97a4dae706df5da344636bcb5f91f5b4f6"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90f802eaaee3cc27a7234fc56a4316c8ebff00279de1a92b718e6aa7f8c8cafa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90f802eaaee3cc27a7234fc56a4316c8ebff00279de1a92b718e6aa7f8c8cafa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90f802eaaee3cc27a7234fc56a4316c8ebff00279de1a92b718e6aa7f8c8cafa"
    sha256 cellar: :any_skip_relocation, ventura:        "5f6657b6fe28de7b518aec0f4d1f9016d6e4b87f10a2adb2a53678f1e7ecbb81"
    sha256 cellar: :any_skip_relocation, monterey:       "5f6657b6fe28de7b518aec0f4d1f9016d6e4b87f10a2adb2a53678f1e7ecbb81"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f6657b6fe28de7b518aec0f4d1f9016d6e4b87f10a2adb2a53678f1e7ecbb81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68132dbe6fc943c66ad2373031af3e149d866b0cf67db1b62b10792bb905350a"
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
