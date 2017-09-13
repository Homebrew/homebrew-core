class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/kamatama41/tfenv"
  url "https://github.com/kamatama41/tfenv/archive/v0.5.2.tar.gz"
  sha256 "771679a32b221d3258e31d839bceffe56ff65567628a47e5831da9ca9f62d73b"
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
