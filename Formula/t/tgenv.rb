class Tgenv < Formula
  desc "Terragrunt version manager inspired by tfenv"
  homepage "https://github.com/tgenv/tgenv"
  url "https://github.com/tgenv/tgenv/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "241b18ee59bd993256c9dc0847e23824c9ebf42b4d121db11fbdff9ddb6432b2"
  license "MIT"
  head "https://github.com/tgenv/tgenv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b51fcece0e2a8b77f96f8460b123aedb1ab6cd9497b5da570e00639258324ece"
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
