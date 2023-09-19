class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.51.2.tar.gz"
  sha256 "38e002ffaaf12e9c5b1aee11126ec5edc047a10e0b4e34253f4c506b2dd51c70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf02ea473de78a2403abd7340ed02bf9db06e4423a3b4d7244e53bd8e7a61c9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26729b64e702881f6cadb7e9bf00df7c5765737cf353d9458f81c42650b04ef3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "560e6d1397eafb00717ae8ec0b8e26c2ca2656917633ef0a6f5fdfaa4c516490"
    sha256 cellar: :any_skip_relocation, ventura:        "b5f1e00b62a68808c87a2bd39813b2fb641c5b3bf4dc352fbbba8c85ca07942d"
    sha256 cellar: :any_skip_relocation, monterey:       "f8cf9f2da9ec2cc162efc39e5850afc1b44ff48a2b06ee94d0fb0245f49591e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "02b1a87cc34e905240a10156001506f9a78556b24c891faf43b9cc6a63fde068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c406fdb2d23c937ff9dd2b5ceab523b0ac51e125a5cd9f201f1968497851764a"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
