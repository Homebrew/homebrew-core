class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.15.3.tar.gz"
  sha256 "c9ea33994de4c4600a403fd6c90545d3481b60fe4e5e96318dbc28c40faa7c68"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "12682b135c7688704906dc2c8e40c518a7c5df498ebf9afe31cfdd2d390f3f42"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f08de710ecc0713fa98fc9086fa08ece8286b96f03fb439929560869e70e289"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21a686a8625d95c913be56a080eb34b3f5abba2cc578aff14479c23046f46385"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "71efa382996c6045d5681db82b9602f252df11ff068996d801705fe28ee482f1"
    sha256 cellar: :any,                 x86_64_linux:      "b8875ebe746efc820f9e81eecc94414b56ed31d88e3f6da5da705073125de736"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=#{version}", output: bin/"rancher")
  end

  test do
    assert_match "failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
