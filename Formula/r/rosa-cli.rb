class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.63.tar.gz"
  sha256 "9b4baafc16ad9207285aa7d5bfeb0db0f47b07f9e821a71462b3867c85b8b276"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d83bb6b221bfea2d4d9c32fe0064f62395f7b44e2bf52b11ac49eaf9bea0fed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e6cabde04c64fd6d920ee08feaa3997fd2529c219a00a9f7139713183cdce1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a970033c686452f9ff399875ad5bb80ca2672ceed38a4c0d678f8e79eba49263"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2820fa70a8e9f3e0655e1fc57501e69974d85c52b5be73cf4b476a6a4bba832"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cb7a1d2d302cc864b27db1e1bc9b8e5d6f070505a632ea2aabccbd1e2d5bfe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52ceeb8a64addb2f484c1ae98b704622d3c15b85110c11cbbbd64038f410d4b9"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
