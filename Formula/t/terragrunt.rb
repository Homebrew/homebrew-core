class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.72.2.tar.gz"
  sha256 "6f1c2e9c57fbb6958134b0bf648769c8f3ed0db15cb42770221cc32303c679a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec6332380f3c00fd1de75efba8da561009513b56b61c895b84336e7c0c558f47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec6332380f3c00fd1de75efba8da561009513b56b61c895b84336e7c0c558f47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec6332380f3c00fd1de75efba8da561009513b56b61c895b84336e7c0c558f47"
    sha256 cellar: :any_skip_relocation, sonoma:        "f074944f7486a4c5742ae467ae6fb7af1cead60760325b68a8e1c2a846396b6b"
    sha256 cellar: :any_skip_relocation, ventura:       "f074944f7486a4c5742ae467ae6fb7af1cead60760325b68a8e1c2a846396b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1988a603a3757bfe75b6295ba6c80bfd0ec1d340916ee82b8344ae09c789d44"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
