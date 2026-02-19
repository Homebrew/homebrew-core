class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.13.2.tar.gz"
  sha256 "e3c12899efe4f1c98af5e676d7e8a637f3b6115ad0391013a10e58058bfc1e9d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d964a4af23907a25cfe74f9183296efde48778474f0cb5a06587ac1adb7f993"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "def67b388bd9c714c6d8acbc5df20d2bb518e07b5980f19a9bcc7d8e0eed8a35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22448300a2bc3dcaf200df9db32027dfa613378d3582122bec698a74c00c1336"
    sha256 cellar: :any_skip_relocation, sonoma:        "83a1d35e90ea6ac12987372e2b569f7fac68e875103c743e4c3fbebea97b350e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fce38158bb9fd7053a5153a3cdc8dcc17e65953a0fe6594d97170a70c89c0f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d07a6f886178c85fdcd9bdb18832698cf6efc2eb9295b61319693a493876ca38"
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
