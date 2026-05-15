class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "a40f714f32bcca2383938844d39d6211878ae469c2f6d04ff0b903dc20c30642"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8852109ac9b161f376219d9f8a786ba25c61a86fdfcb0d2cb657c5eeb0b8cd6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8852109ac9b161f376219d9f8a786ba25c61a86fdfcb0d2cb657c5eeb0b8cd6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8852109ac9b161f376219d9f8a786ba25c61a86fdfcb0d2cb657c5eeb0b8cd6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f97c90584c2c2bd00cdd16d26a1fb214733b16f994a9bbbc782754807f1ba8c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cccc9d6b98c33e63692bf10f977c1d05a21fe75cbc7ede5ec3a720f17f37822c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24fcc5a8ef089e899507f7cd704f57f95a48b59a00e75d8a4cde9d79f8369cfa"
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
