class Tgenv < Formula
  desc "Terragrunt version manager inspired by tfenv"
  homepage "https://github.com/tgenv/tgenv"
  url "https://github.com/tgenv/tgenv/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "241b18ee59bd993256c9dc0847e23824c9ebf42b4d121db11fbdff9ddb6432b2"
  license "MIT"
  head "https://github.com/tgenv/tgenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5d9c35f1dd3856a985c721d8e0f2d33b656f207092ea5f836ed878e03bba7505"
  end

  uses_from_macos "unzip"

  conflicts_with "tenv", because: "tgenv symlinks terragrunt binaries"
  conflicts_with "terragrunt", because: "tgenv symlinks terragrunt binaries"

  def install
    prefix.install %w[bin libexec]
  end

  test do
    assert_match "0.0.1", shell_output("#{bin}/tgenv list-remote")
    assert_match "0.73.6", shell_output("#{bin}/tgenv list-remote")
  end
end
