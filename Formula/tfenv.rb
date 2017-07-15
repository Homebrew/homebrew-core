class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/kamatama41/tfenv"
  url "https://github.com/kamatama41/tfenv/archive/v0.4.4.tar.gz"
  sha256 "decbd1e871d3da5e7b1299ab3d36852dbb94e3932bc3b5fad047c0488e4eac1b"
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
