class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.12.2.tar.gz"
  sha256 "8a2d1a0efe02de5cab44550f4c58dadacc9a6c9c89fa0a4437f714110ed7a9ac"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72be43f2cdfd113a01e8f21eb10ae9d32b54fcf57f9bc872902c1a4d01025223"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75a9c32b4bdbc6c4dbd72b5e777d2ef8b04fd3d3cad83d8032822b63e28d4ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e706d8c22114a69941867fb1917d586ed6654a037e1c8f69637912d823a9d02"
    sha256 cellar: :any_skip_relocation, sonoma:        "1805115f71f933f126f4ca9f856966f6715ed3f29a01ba3bd340a7a69fcf779c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd0799563d93ac8be3fecb2b3651775f50d1cbed2eb10377694f97bab7f7e6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97aedea4aaa6d97294326dafbd3dcca923a88882fc7bc6a5eb6bf009791574c9"
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
