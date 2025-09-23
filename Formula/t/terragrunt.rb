class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.87.5.tar.gz"
  sha256 "88ec6b242f8342bd5d530f9a96f110df8840622a3991ea7602df72fb1a07bc3f"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b505c9ffd766725cdedafa0c0dd9440f7eb488a2c2430d0ead23dc501118a3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b505c9ffd766725cdedafa0c0dd9440f7eb488a2c2430d0ead23dc501118a3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b505c9ffd766725cdedafa0c0dd9440f7eb488a2c2430d0ead23dc501118a3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f95776ba10fe61b9a37d3c371b256f50da35e17904e656d8b2e2f6da6491461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e01bdf6960ecf102fcf4a7a4b611a897a3ef49b0557dec260a1f4e1c915fb8"
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
