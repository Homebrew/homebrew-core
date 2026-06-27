class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "971df2cf1f433e2b79688ffd880f6ea5b7f1c90cf63b8c1582a3bca7e7ea6b6c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b6859f85cc52d56cae03b8cc32e2665b5e86e964433e0cf3ccdec0611f09ae2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdcbcce0e7659e8eb630829f8b38841a460492b13caf1f98aeb5598a2a7cca20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f17728df1c7c55b80a89058b5dd47897e4c6f8e4bbb407eef2330f6e11794eb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "49dc43c15467f19c431fc1e8ac1f92ac0e3f63e3546ebda5176def3343654ffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e63547f300b0328da1f382d6816a8eccfd7900e0dc6104d9b8c352b7a807af31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94088d3a0505c4f54bfb95970307648101cef0963465a12453161f3249b10516"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}", output: bin/"rancher")
  end

  test do
    assert_match "failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
