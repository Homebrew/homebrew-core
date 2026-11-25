class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "4f80482960f2ebbde94a0471e8fb0e805046ef31ef2f6c04716502bcef81a180"
  license "MIT"
  head "https://github.com/gruntwork-io/terragrunt.git", branch: "main"
  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "f57fc0fc157ca7b412e4d82fac19e9c8b173b6ac690233c8f809388f582e4bb9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2e3170eb77ee77379ec28d0b710de4a9c26da838be9d2efb95f220825bebcf2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2e3170eb77ee77379ec28d0b710de4a9c26da838be9d2efb95f220825bebcf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2e3170eb77ee77379ec28d0b710de4a9c26da838be9d2efb95f220825bebcf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3037ab4be8410c53f7a520b5516bbe07ea8c4f21b6bddfecf2a8dfb7975d9849"
    sha256 cellar: :any,                 x86_64_linux:      "58154ad515363e7809c101c3275c065ecb407c732f027ee2b2f05cb58cd72aa2"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/gruntwork-io/terragrunt/internal/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
