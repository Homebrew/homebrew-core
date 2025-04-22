class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.51.tar.gz"
  sha256 "217c4ece00169eb9f7a5cf92efba928d20baa69753c44c5be6fa7d5f857be7fa"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54aa498005b23a600bd7fe16550a103b81b051b209c4f4bb7e8f489d8f2c683d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef77e07b8ce383a140aac0b8c9ff48c598ac7d32add78c90aeebbe4ee19e2dcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f6b6fac8cd77dccae6160f4d6d43ea38b4838369a637ca7c82c4d3a09a1159c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b8a5a7acb161545a8d10155a6eb43f98d964e37b182d76f8e9b102f51e36ebd"
    sha256 cellar: :any_skip_relocation, ventura:       "19c1a140274ac1c89cfd89fbe5d6ee2369db5eef37fe6ba4dd0ab4765c04cb21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b397c3f8222d023e7ddea54bf1e46a9268c3ab089840a60651aa52d506bf1f"
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
