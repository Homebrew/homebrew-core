class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "6e8fea75ba3f6584e10edeab4db53e15453677ee80489b2d550c96eda5c2ef85"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61aaae188185092c639ba51dd36895b18d934ee57f29ba9a48891ab701dcbd67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61aaae188185092c639ba51dd36895b18d934ee57f29ba9a48891ab701dcbd67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61aaae188185092c639ba51dd36895b18d934ee57f29ba9a48891ab701dcbd67"
    sha256 cellar: :any_skip_relocation, sonoma:        "828a5d55e445a0c5be63da9821e3f241b6b8c08e3a813fab87400ed60cf845ec"
    sha256 cellar: :any_skip_relocation, ventura:       "828a5d55e445a0c5be63da9821e3f241b6b8c08e3a813fab87400ed60cf845ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc692c054797e3dd5b796904f2d8e884ddb6680a94f989bc2ad60379371d7de0"
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
