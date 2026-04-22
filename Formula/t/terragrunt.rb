class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "e6310bc395d6cde4648c806d41b5cd6b2c22cf1e3ffa30572b736ce228bafae6"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "044d51d32b5686a87c00e1087b14d01543c6b9d4ec21063dcb38d95614a30764"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "044d51d32b5686a87c00e1087b14d01543c6b9d4ec21063dcb38d95614a30764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "044d51d32b5686a87c00e1087b14d01543c6b9d4ec21063dcb38d95614a30764"
    sha256 cellar: :any_skip_relocation, sonoma:        "684b540504c017de44c2d5ea864b45b4eccd2a8bb8224b70902f818de71f196e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9ea1ca0c092771b7ff7e16b205f0361c31119cdbf05eb85a9ae15c1559daa6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f65488818d01a043565a0d7a2bf20956a98a8b4b88c280604afe84efbb54476d"
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
