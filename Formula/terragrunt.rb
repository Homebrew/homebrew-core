class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.30.6.tar.gz"
  sha256 "927eb56c6b4ceca4a6cac145c559505df7a3e3ff45655fe89de8a0fafe0c60dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "02d9a31b6d1823047145cf2f800f15cd79437291f6e3e118eaaf8d0c61f31db9"
    sha256 cellar: :any_skip_relocation, big_sur:       "74aaaef3c20971b5314e9f998cb49c28ffcfdcb6b4df50cef5890715e3bcaf4f"
    sha256 cellar: :any_skip_relocation, catalina:      "55122ce10ec2a199338aa4bc618fa264f5aea2c2623010f29842ae1c48d4cb87"
    sha256 cellar: :any_skip_relocation, mojave:        "4b79daf32709914d63c77c9f6853c2c97421f3ce93981c483c5a1d5df4c186ac"
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
