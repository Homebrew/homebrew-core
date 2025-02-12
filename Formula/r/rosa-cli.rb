class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.50.tar.gz"
  sha256 "bfbcef9b7a15e4aeb256420126e0489b6e595121e991a5c211968e0f6ebdcad7"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "910f77217c227af4a23efe6eaca5f30a3cd44961d9309904d79aac70af204898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73edbb7a9cf46b6b00ab52eb897932c072f3f39a46e8a04962e9dfab66d78259"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0efff9eb67702302901f58718789980cafc540e1297575ee6e03173f3e115d86"
    sha256 cellar: :any_skip_relocation, sonoma:        "64cfb26cfe7dbe0098aa733a3f5018a63ab4fec4abd0cc7573aa5129e946c60a"
    sha256 cellar: :any_skip_relocation, ventura:       "c68416b8e18d55be56c4fb4d258326dba19bcedf7015b6f56066c3563c2aa1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ead50bb905841d60af80ebb573ea8cbfb99eff095074c8551728d2eb2c1c72"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", "completion")
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
