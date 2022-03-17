class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.36.6.tar.gz"
  sha256 "adc7b9d651188cfaadad4ab181155e13a528bbff4338144b104c233e5b249b8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5873f6cfed176559c4bbb7f99096ea2a58906400083ff11ffe8f251c02ff2be9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13b34d8ebf722b9287b00795d724397186d91a5b15407534007c33e4e72ae69c"
    sha256 cellar: :any_skip_relocation, monterey:       "bb8d8315227410f092585a43b11d0b4c8c2ab0759870c2ada7ce16e018248684"
    sha256 cellar: :any_skip_relocation, big_sur:        "878444fd87c7387ca4a69bda3f4bd45ad75a5030ed26cf12ee5a4222d0ae05a9"
    sha256 cellar: :any_skip_relocation, catalina:       "c8d915f033505c49cbedfeea5adb532a5757d34bff6a5e6e09507df4d1c49a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8c725b3bcda1272ab0cafd4006d2dc0684bc2001946af144706cb5b4e59d12"
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
