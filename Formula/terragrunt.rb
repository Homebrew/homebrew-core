class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.45.0.tar.gz"
  sha256 "e6161d99125a0116d0085bd1e875dd579ce88361f7bb5db29b5b7bce31015fdd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce9bbcb27a345c9d9041fa90511abd3b2bf9fe4f52d2babf6665ba9884512838"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce9bbcb27a345c9d9041fa90511abd3b2bf9fe4f52d2babf6665ba9884512838"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce9bbcb27a345c9d9041fa90511abd3b2bf9fe4f52d2babf6665ba9884512838"
    sha256 cellar: :any_skip_relocation, ventura:        "41584381293caf4e65b26fe2d8b4f5b1b7c8719561e0500548fa83738e5b2372"
    sha256 cellar: :any_skip_relocation, monterey:       "41584381293caf4e65b26fe2d8b4f5b1b7c8719561e0500548fa83738e5b2372"
    sha256 cellar: :any_skip_relocation, big_sur:        "41584381293caf4e65b26fe2d8b4f5b1b7c8719561e0500548fa83738e5b2372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e92ba83f87a534f006756158e1a12a898d709ae44779436788d470150915842"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
