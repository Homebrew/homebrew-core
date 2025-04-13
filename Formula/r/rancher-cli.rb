class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "91f87208d08b5beadb88380ba29da2ba61d11cbf78843572865cf0f2a0679df2"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cf85776de55173717eadb6c1265823b05adfd36dcc6c57b553915b6472decec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf85776de55173717eadb6c1265823b05adfd36dcc6c57b553915b6472decec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cf85776de55173717eadb6c1265823b05adfd36dcc6c57b553915b6472decec"
    sha256 cellar: :any_skip_relocation, sonoma:        "3865334669fcfacbca3f78a8a0e1d850d84cfa81cc8a8dd51fc02b75b25c2fbf"
    sha256 cellar: :any_skip_relocation, ventura:       "3865334669fcfacbca3f78a8a0e1d850d84cfa81cc8a8dd51fc02b75b25c2fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abb9644589340d34783048fd5b87c4d8520b67a2ca7bc63ed7b3a641bbf7c655"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"rancher")
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
