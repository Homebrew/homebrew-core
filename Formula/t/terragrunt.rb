class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.80.4.tar.gz"
  sha256 "b8de3422bb86da3fb6d2170aa4a35e1679aef228985fe5b683120866fa4fb591"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "257d94d6699fa344eeff5eb93fe280a2f015134db3e8d064f5e6dff02ddf6450"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "257d94d6699fa344eeff5eb93fe280a2f015134db3e8d064f5e6dff02ddf6450"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "257d94d6699fa344eeff5eb93fe280a2f015134db3e8d064f5e6dff02ddf6450"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffb779378922b8d7ff6b27397aaa81544f36d5001b58d7f975c7d4a0fe2607d3"
    sha256 cellar: :any_skip_relocation, ventura:       "ffb779378922b8d7ff6b27397aaa81544f36d5001b58d7f975c7d4a0fe2607d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d299280edb6a079bfe30165316f94c7b11c53384b36695d5b25bb6a1fec1757"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
