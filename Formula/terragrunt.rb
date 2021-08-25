class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.31.7.tar.gz"
  sha256 "3be1183699e58f04ff9bbce1f68cff4d26d927e077089213d6853d076198a55f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e2963ea09f4078f4d6216f3526451c9b9cabc831b7f5eda092cbc2c41fdf0cba"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d517d577f1026777c870f3bde364d4c3922c5d0b4515d2f2faf31ee478b496a"
    sha256 cellar: :any_skip_relocation, catalina:      "c8560ce26c8fd5af8119e0abf73ccb72f3086926cd7fbf58dd2e0d582e93f943"
    sha256 cellar: :any_skip_relocation, mojave:        "e6be2bb29c3cf8e261d6edd36656d3e507403c96133f25863d00a94514808c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d522e56e82063fbab284c3b37832f2c9b908cf420829be53a365c40bfbb5fad"
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
