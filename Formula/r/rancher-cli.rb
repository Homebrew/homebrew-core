class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "8bb8021fca3c5dfe2f6a0d4667dc1920d6198c06832bec1e5827c86d3ad88db2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64f976260ef10d70293e840daeaf8e336b25a86bbbb5792d6ee13b8f7fea548e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a80f6164ac34d727ed3197432f36aff69150bf2e506474bb423d8e7437eac740"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dc72e742fe408efe890553d5be8c90f5467004a7a3c11906a918051557cf532"
    sha256 cellar: :any_skip_relocation, sonoma:        "adf455921f550f89f62d802f06ca69f1e938782d8bdb4d3eb6333e35960878b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15179abff15dd4c41e064f28bf893fa54c200f95fd88a71d2b5ad2805e952d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3c6f37dae2a48c9b8160b636cbe4be8805aef8ddd61c001b093e425bb7de61d"
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
