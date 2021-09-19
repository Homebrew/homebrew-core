class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.32.2.tar.gz"
  sha256 "d543a713421dc8fdb67ae183a4cb6de435455f03c2c607d4214d0f5c4373c3d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "390d37ababda6c23eab4f0b1ec3da8dcfe917960ece3f67139d7b85742cc67f6"
    sha256 cellar: :any_skip_relocation, big_sur:       "9952701f40299cd4741b9ade54dd2a0e636dea3737d618180314e7b742e0d0f1"
    sha256 cellar: :any_skip_relocation, catalina:      "ef5cd72e5e0ba07f8de0d39eeeb6b5ac695262c020a10b04b0f563f99330c180"
    sha256 cellar: :any_skip_relocation, mojave:        "beaa09f83f85493a680585c2e5cfde496813fdd60b20cc480958b08f2ad1147b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "658149361b19af73ed1000ad7fc21b6010410727e7a32932ff40c8c18bb6d634"
  end

  depends_on "go" => :build
  depends_on "terraform"

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
