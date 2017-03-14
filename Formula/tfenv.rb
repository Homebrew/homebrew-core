class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/kamatama41/tfenv"
  url "https://github.com/kamatama41/tfenv/archive/v0.4.1.tar.gz"
  sha256 "f2f7fbd3500d2ae1aef1e2ba51b2f2b81e7cff831c1a63c8a41ade7bce93186b"
  head "https://github.com/kamatama41/tfenv.git"

  bottle :unneeded

  conflicts_with "terraform", :because => "tfenv symlinks terraform binaries"

  def install
    prefix.install ["bin", "libexec"]
  end

  test do
    system bin/"tfenv", "list-remote"
  end
end
