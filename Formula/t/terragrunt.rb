class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.80.3.tar.gz"
  sha256 "77c7fec4b5e0e44591d7481b73a6e85486e63252a3aaead49253793c8f2d2ecd"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ea0cfd051205dffab213fce6b4a319f5809911d7d32795158ca058272aed965"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ea0cfd051205dffab213fce6b4a319f5809911d7d32795158ca058272aed965"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ea0cfd051205dffab213fce6b4a319f5809911d7d32795158ca058272aed965"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb9fab4c15ec498aa5290f2d29e5b57e4b1e020d9a92f0be79fef48ab21d50ea"
    sha256 cellar: :any_skip_relocation, ventura:       "cb9fab4c15ec498aa5290f2d29e5b57e4b1e020d9a92f0be79fef48ab21d50ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3f664662ccfa7f029a6b9fff66cde5288db81211bf53ef2fc1d120822aa24d5"
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
