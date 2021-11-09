class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.8.tar.gz"
  sha256 "226f6e0d8a60e026cb0d4fc0f41b4314ee14cbab78e23f05376259b254eddb2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "069895842a1030303ba581f9ba9d409c1b277c1d66d36c11fbcd8a5e799ab605"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a39a634d05b9f7e20592b78defc111324ec2fd496ff40f911c7454a22c764b3d"
    sha256 cellar: :any_skip_relocation, monterey:       "b1fe580bff585b917876ca8ea9a50b1592fc0030db55f91ff7b32e030f1a35b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ab24e5e6e2e2fe313dd412ff9c845e2a70a7f9c8fe9b0fa43f5864ceb4ced35"
    sha256 cellar: :any_skip_relocation, catalina:       "afd1245a73be4aee31de3b457ef616393e6c715cdc0bb8f7ccc285cbe14a4b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6423ac6b0518790d1c24f2778adbd9b1fdeae7d4f6e85eb81476f017e2993c"
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
