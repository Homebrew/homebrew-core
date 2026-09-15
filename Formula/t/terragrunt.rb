class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "f2bcb7de559d8e5a9556ea272a5cc9d86ff75054dab484e3a9f820bf8fcfcbf5"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85cd32365a984e0de3d68a5d94829560237836495e28d1942e06621416cb32a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85cd32365a984e0de3d68a5d94829560237836495e28d1942e06621416cb32a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85cd32365a984e0de3d68a5d94829560237836495e28d1942e06621416cb32a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "78d78ce2fb4197d2b251e637703e38780dfb34cc93eccae6d31656bb8abd8ebb"
    sha256 cellar: :any,                 x86_64_linux:      "318817adbdf7ab1b53662ab2b6085dcba53c08323b34182853be9b55733bdf04"
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
