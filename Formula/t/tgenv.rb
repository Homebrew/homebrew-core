class Tgenv < Formula
  desc "Terragrunt version manager inspired by tfenv"
  homepage "https://github.com/cunymatthieu/tgenv"
  url "https://github.com/cunymatthieu/tgenv/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "e59c4cc9dfccb7d52b9ff714b726ceee694cfa389474cbe01a65c5f9bc13eca4"
  license "MIT"
  head "https://github.com/cunymatthieu/tgenv.git", branch: "master"

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
    assert_match "0.58.1", shell_output("#{bin}/tgenv list-remote")
  end
end
