class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/kamatama41/tfenv"
  url "https://github.com/kamatama41/tfenv/archive/v0.5.1.tar.gz"
  sha256 "dda9d6bf205c47fac1cb8fae6750a4fe26bbf8fff7765f1f7b03ce45862ef404"
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
