class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "38b05e840228a1a3c4a18541b297ccb58d171343eb6a697b9946d8bef6c993e3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cf3bf65f19590e05148935e872cf1157a6da4ed027ea802f1e5e65d761d3e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c139c5eaed0537556fe113a7355f45e4db4634ca330a0113076587c77daabbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95b380a751c54a616b97a40c91eff4850f7a124ee37b90d9a6ad9a0d35ee7ef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aa3d2c8993388234970cb0016710673d9d4ee16e47806500ad3d1401c19da32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ef056160cc892ffad81212f7a288938da0d30c17430530a0d591b8a7d230417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bd2fad5a7138808f0237e480769334d954e8093ca3485f77aaa844232e00dfc"
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
