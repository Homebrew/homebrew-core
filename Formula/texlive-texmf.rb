class TexliveTexmf < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "????"
  homepage "https://www.tug.org/texlive/"
  url "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2021/texlive-20210325-texmf.tar.xz"
  sha256 "ff12d436c23e99fb30aad55924266104356847eb0238c193e839c150d9670f1c"
  license :public_domain

  depends_on "texlive"

  def install
    Formula["texlive"].share.install "texmf-dist"
  end
end
