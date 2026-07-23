class Tgenv < Formula
  desc "Terragrunt version manager inspired by tfenv"
  homepage "https://github.com/tgenv/tgenv"
  url "https://github.com/tgenv/tgenv/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "cccf0d5714cf1156aaa9f451d98601afa3e7bb0b104eda61013a9a8849bee2fb"
  license "MIT"
  head "https://github.com/tgenv/tgenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41d63971b87c2f8003c821f8cfc00eaf264acef2560a75c7e0dc631da4a726a6"
  end

  uses_from_macos "unzip"

  conflicts_with "tenv", because: "tgenv symlinks terragrunt binaries"
  conflicts_with "terragrunt", because: "tgenv symlinks terragrunt binaries"

  def install
    prefix.install %w[bin libexec]
  end

  test do
    ret_status = OS.mac? ? 1 : 0
    assert_match "0.73.6", shell_output("#{bin}/tgenv list-remote 2>&1", ret_status)
  end
end
