class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.43.0.tar.gz"
  sha256 "8a4c257ee3f65f9c97d17400aeae705c644fc371393a2df3cd264afa77a1f813"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "514a94588d6f7e3f37a0161747da8020ae44c9ad12987d979f9019bdffa05a99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b713b9a7e21e9175726710ebaeaf145dd1b633fa8c5aa55fa3491b6a6d78979"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1236dae0efe5d571c36d12d004b402c5680a029c7236b8656fd1f3cc54459a0f"
    sha256 cellar: :any_skip_relocation, ventura:        "2abf33499242e25653ac82e81acbbc1f695530b9e9663bac49e2a9b1b1600c67"
    sha256 cellar: :any_skip_relocation, monterey:       "ca5bbeace55fca32b5225c79d4bac3823043c4da82209bfeaf9873b8fe679336"
    sha256 cellar: :any_skip_relocation, big_sur:        "18d25d86ac322b77dd39032fb3be298bce3cf1878cc103b78f972dcd07a4f397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3eed5303298ca65c7fc9e60d12d61b2bddb4c1e70f6960d3fd892be3e0fd67a"
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
