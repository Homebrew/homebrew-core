class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.10.tar.gz"
  sha256 "81b39776f9dd1d9463708b76e505c32082f66c55c4bc592a68029b8507d2478e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d115422d80238a408450bb079bc97237d1ef94ae10970aec81cac839027cf5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "596ed38eb25a4bc13ccee267df2d07e02d10f84ae84eb5e10c540fdcfe211883"
    sha256 cellar: :any_skip_relocation, monterey:       "4221c8a8900f53fcafc88d82d9c121364e441d42dc2aaf4c35e095aa8568d52c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5fbc5d76bec06db3103f1ed37ca57b71f208d817b68709aa97c8bbaa5bd7fce"
    sha256 cellar: :any_skip_relocation, catalina:       "961198cee9c3ddcb3f395ee53864fd7c7a9f71fb0aa44b26c5009f2fed23e992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f3747f106d12d6d46237a24ed360b4389e64d47680a36ba7c32a36f96182b0f"
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
