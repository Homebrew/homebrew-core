class Tgenv < Formula
  desc "Terragrunt version manager inspired by tfenv"
  homepage "https://github.com/cunymatthieu/tgenv"
  url "https://github.com/cunymatthieu/tgenv/archive/v0.0.3.tar.gz"
  sha256 "e59c4cc9dfccb7d52b9ff714b726ceee694cfa389474cbe01a65c5f9bc13eca4"
  license "MIT"
  head "https://github.com/cunymatthieu/tgenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ceef88ef9082c454a7f9cb0b6833b0a1b3df5147d46cb658a485659ecc081c60"
  end

  uses_from_macos "unzip"

  conflicts_with "terragrunt", because: "tgenv symlinks terragrunt binaries"

  def install
    prefix.install %w[bin libexec]
  end

  test do
    assert_match "0.40.0", shell_output("#{bin}/tgenv list-remote")
  end
end
