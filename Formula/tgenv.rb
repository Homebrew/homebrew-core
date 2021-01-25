class Tgenv < Formula
  desc "Terragrunt version manager inspired by tfenv"
  homepage "https://github.com/cunymatthieu/tgenv"
  url "https://github.com/cunymatthieu/tgenv/archive/v0.0.3.tar.gz"
  sha256 "e59c4cc9dfccb7d52b9ff714b726ceee694cfa389474cbe01a65c5f9bc13eca4"
  license "MIT"
  head "https://github.com/cunymatthieu/tgenv.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle :unneeded

  uses_from_macos "unzip"

  conflicts_with "terragrunt", because: "tgenv symlinks terragrunt binaries"

  def install
    prefix.install %w[bin libexec]
  end

  test do
    assert_match "0.26.7", shell_output("#{bin}/tgenv list-remote")
  end
end
