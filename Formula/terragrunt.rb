class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.7.tar.gz"
  sha256 "99b24f1b88f3b1df3eb69978373d93b8fcfb37a2c3d1a7f944a78b2071b67a5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2dce01ffc831b793dc0255bc8bbec12725fb23e4905ce1c84f0e14ab0827b82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fd9e63824817d4aeb9c162e2616e8ca69ec4017b019afaa4b54340f7485c186"
    sha256 cellar: :any_skip_relocation, monterey:       "fd3b4249e271d1e0b02529a08da2ce15f8f6a77dbb0446878ff265893ab99fd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "83b10ca063c8c6dfdbe3dc62c6c1d28b8c032939a93c207a6b872a08bb010246"
    sha256 cellar: :any_skip_relocation, catalina:       "00b3abf2576f0a879516e21e9f14612b47fd22513cc47aa0c091ecdd7f7bd8eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1221aba3d474177a43221eab30e47943117732f5ddb305fdf2e058edeff53e8f"
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
