class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.73.16.tar.gz"
  sha256 "99d94288f99116accfe461547131aadcdd9cff00b87f8951f3b395cf2606dca1"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92a0177e04846ed089bd33e2ce426621b06ceabd526327368abbf0c84bf44ad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a0177e04846ed089bd33e2ce426621b06ceabd526327368abbf0c84bf44ad3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92a0177e04846ed089bd33e2ce426621b06ceabd526327368abbf0c84bf44ad3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c953ef79ec140603d77bb19f217fb48ba32e5f54fa838a90f7b533c5411a13cb"
    sha256 cellar: :any_skip_relocation, ventura:       "c953ef79ec140603d77bb19f217fb48ba32e5f54fa838a90f7b533c5411a13cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32672468d85d6279848ec64d01015181c618c519c35875efa8dad41b0cb81d9e"
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
