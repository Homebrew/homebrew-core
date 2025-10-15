class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.90.1.tar.gz"
  sha256 "1ed986d81ef1f930fd2a10e418960dc38b4c3b0e325b3900fd93c0a07fb8c779"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "427b9cee0fe9056250de4c5ea1a91748308e0febe927471360d2229e8ba801cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "427b9cee0fe9056250de4c5ea1a91748308e0febe927471360d2229e8ba801cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "427b9cee0fe9056250de4c5ea1a91748308e0febe927471360d2229e8ba801cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "88cdef159e7cc816323a40704d654eec746f4c3cad9fee075012b938c7c57ec5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "719b583d8adee56e81e254376fde579c124958be21cbb7014515c45f057b2853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bc5da5793580b7fd4023899c2061ac8cb5e59312651aa13f000d65847040ba4"
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
