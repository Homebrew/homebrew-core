class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "910cfc7dfceef54226184da35cdca0b117a0b08e7d97485cdc2a78e4d046fd09"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55b13d67b071e3fab3d41c4c46a422a22e25c1307dba008a71f91e6011bc4e4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55b13d67b071e3fab3d41c4c46a422a22e25c1307dba008a71f91e6011bc4e4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55b13d67b071e3fab3d41c4c46a422a22e25c1307dba008a71f91e6011bc4e4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a191ce840db2f4fa8800553f0009f16c52c9d24fe7b4876db2dd8c0f451ddae"
    sha256 cellar: :any,                 x86_64_linux:      "52a81034922c8097d5de8e524bb8b8bf3438ab6805c6335c844d3c754933e21f"
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
