class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.38.tar.gz"
  sha256 "8d335317c4220f1c0982e68727a1c7ed666c3429c606bc0fcc7d35507ea78bb6"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bf96699cadff4ac70340073265518a0467b1ec0181591fefe80c10a47f5c2b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cca0e4eabd1e3cbd5397582f05a379789b3c1df0f01c56a675f8e41a48af74ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ea1c1aec38df9ab31fbf569897e1f26693403757d5798ced38dbbd328591649"
    sha256 cellar: :any_skip_relocation, sonoma:         "8797e5ca843697feb8b0ddb439e6ff9a28086f9324ccc14b488cae7f531cdeb5"
    sha256 cellar: :any_skip_relocation, ventura:        "71d62b91b076d4064859988ea9d13a935b3da284938d274a552f9967350d2959"
    sha256 cellar: :any_skip_relocation, monterey:       "162ff66e453a4394d256c3ca72544f626e11c3ba96fc8f4f94c6722021a00a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65b6ab3b9d04c85295248f08ee82cf81ce1fc5a76c979cca5cc856caa8a83653"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
