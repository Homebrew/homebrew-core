class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/tfutils/tfenv"
  url "https://github.com/tfutils/tfenv/archive/v0.6.0.tar.gz"
  sha256 "f2ca32ade0e90d6988106e85efaa548ed116cac1ded24f88dd19f479c6381e2e"
  head "https://github.com/tfutils/tfenv.git"

  bottle :unneeded

  conflicts_with "terraform", :because => "tfenv symlinks terraform binaries"

  def install
    prefix.install ["bin", "libexec"]
  end

  test do
    system bin/"tfenv", "list-remote"
  end
end
