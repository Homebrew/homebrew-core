class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.31.4.tar.gz"
  sha256 "8d1cbdaf4f6a985cc9a2bd98dee50823bd102286e604022f7746ca0bb27f0e21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "496daceaef5d8052720f0dac39ef52433a9e0e7b97769520416a7b4ec61be68e"
    sha256 cellar: :any_skip_relocation, big_sur:       "4fa52e975a4accf07b746c4538274fca8a7d36321867305f91a3c97ccec17414"
    sha256 cellar: :any_skip_relocation, catalina:      "a42ada888d85809049d6791699ec9858ab1642da80ce9aa9d97a8817d8f1dfe0"
    sha256 cellar: :any_skip_relocation, mojave:        "fdf119d28a0499d261bc00bdd80a5bfeb12d569bf39fe236abf8cafe444642a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3601c8e99aa51f1a427949538403ce37f785c86ade3dd83172dc897a5d5e4db6"
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
