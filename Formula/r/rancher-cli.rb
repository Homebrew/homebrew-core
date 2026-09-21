class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "99a9a459c2e366944d0fbc238b63077582b807b1cc5cb568653dacf13236b934"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1cda1396c325d91bdd416538979c392aff5e46b2082f0a215c6c82f27c8932c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "388b0727343e1da266bf8e2286e1783d29b89fc2edd7d9830dcbc03a5db52db5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3084525cc424ce77ed85b2d9a7001463c6e6b4c7744c30e7dcac840150223be0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a58759dbe1691e82955cf7959323b053351862ad8a355a76e0bdc717409a54bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5314cfe75ddc555a05a93786c27c623583205b1e61f3a3710046103dfcd9b063"
    sha256 cellar: :any,                 x86_64_linux:      "7bee5b23bc5527c15901c90e2e1cea2a017b7297b674265633fa84ff451f7e65"
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
