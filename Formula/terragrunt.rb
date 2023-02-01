class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.43.1.tar.gz"
  sha256 "282179f73e4269df2311aa90d6b13f504f49bf0f3ee0c1dd573f60bc96053567"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4628fe05162ad5b2a8622fcbafbc6939bb0b25c486a1492367831b4e77715b4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "806a6fc175ca51204c44cfcc3306e047173415671ec9e1eb689f0bdb96048237"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "879a64c5ea7b3c2abb642a56c4a6030ac1b6683084cf0c2f9c7fce1e4509dddc"
    sha256 cellar: :any_skip_relocation, ventura:        "9c0c9e75f20d00532d2c8fac61396923f54d2e4bf4fac4a024c18ea9722180ee"
    sha256 cellar: :any_skip_relocation, monterey:       "e7c004f704b6d1efbc8ec564ee4fa5affb3b7e16ea4a50130f12aaa6d07e1d2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2f5621d9ab44eb2052f8556f8953b97b8218b8a009da8a60e777afab0ee1ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "634cc7663a6ce1ffcadef57073c38cac7961d4e8e14472f2d95cea6ac5351684"
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
