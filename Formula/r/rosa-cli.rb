class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.26.tar.gz"
  sha256 "ab1f1de6979f7f896ef4a65212b60651f79e50ff10317c29d91072ba1c4b8c34"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19e03de44dc86ff8fc35186aba3d465ebcd1b8edd8055a5de035dd800590cdb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "605dd6551b0bb35245fe263b3117af8828141f9f222e7cd17eaa65eb6120b588"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59b8b6cbb0c0a300f39905c0cb0040a4b5a44beda03b921f79b8c1f61d2e636c"
    sha256 cellar: :any_skip_relocation, ventura:        "3d3b15442574cdd263ebbbfa0727c754c06ea4eb84c92ac6d603b706ef2c97f7"
    sha256 cellar: :any_skip_relocation, monterey:       "1ed1a6230b2356c802597790dd168bbd1ba8c59042281e207f24d5f9229f7c2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2f507a837c37bd4476c29be0bf5976aa3669b809b37a03bd0719a19a6809c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd214c81ad896989ecd0ac69b26db9eddb3602534cb775183e00c03fc9b6d835"
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
