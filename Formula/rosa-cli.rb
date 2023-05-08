class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.21.tar.gz"
  sha256 "4c649c46030088fefbc3d8342c0b32f8c1c1443b23c745a5c9a9ecf197d27f3d"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30a7f65382dedcfe80a5d890cb30ce19d1b32456e2e3b8bc1a79bce835750d3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30a7f65382dedcfe80a5d890cb30ce19d1b32456e2e3b8bc1a79bce835750d3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30a7f65382dedcfe80a5d890cb30ce19d1b32456e2e3b8bc1a79bce835750d3c"
    sha256 cellar: :any_skip_relocation, ventura:        "19dbdc671f36563c7c878c1895437ed91588ce4282b071ec70e983242340d2f6"
    sha256 cellar: :any_skip_relocation, monterey:       "19dbdc671f36563c7c878c1895437ed91588ce4282b071ec70e983242340d2f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "19dbdc671f36563c7c878c1895437ed91588ce4282b071ec70e983242340d2f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a97e25307ff810270a6be5da01847dda6f6eb120652f71a67caefd5749aa4a02"
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
