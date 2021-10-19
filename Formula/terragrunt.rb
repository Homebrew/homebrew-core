class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.4.tar.gz"
  sha256 "295649b1c397b63d8c130cbf5e61a31cbba09ad116c9b967e8bff69f6b9dfc08"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "923bad771398c009af0dd6ac004f022e82403e022a9521768a7ea141cd34f6b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea4dbb3f5ab97b57108ebd96389682ba8f919faaf469b5758e76a36f4012ef56"
    sha256 cellar: :any_skip_relocation, catalina:      "b27c2d7d35e083f23c53e5c9b47d45813a556a080806e6e9385254a40268c736"
    sha256 cellar: :any_skip_relocation, mojave:        "6ab6eb109073d50c2f32a8bb354f5149845a9ca0318aed5757edf5705202b898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3011ee8704487d9f379c13dd660d347fc2ee592228c9e508b8ad6bc6793848b"
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
