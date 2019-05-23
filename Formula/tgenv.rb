class Tgenv < Formula
  desc "Terragrunt version manager inspired by tfenv"
  homepage "https://github.com/cunymatthieu/tgenv"
  url "https://github.com/cunymatthieu/tgenv/archive/v0.0.2.tar.gz"
  sha256 "0f6dcf1ab3fdf8bfd3d237bfb1cc20e97c2b1895dc40aaae7ea17f2711a444d3"
  head "https://github.com/cunymatthieu/tgenv.git"

  bottle :unneeded

  conflicts_with "terragrunt", :because => "tgenv symlinks terragrunt binaries"

  def install
    prefix.install ["bin", "libexec"]
  end

  test do
    system bin/"tgenv", "list-remote"
  end
end
