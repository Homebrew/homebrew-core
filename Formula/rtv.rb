class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.15.0.tar.gz"
  sha256 "795ac6b253445a1a76b246432393e6e5f12babba0360ed7caac33fca57ced891"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    sha256 "3531d8216decc13e8c7e581e7000c696061a7914826d3e23ea3ff708b43d58b9" => :sierra
    sha256 "c36814fbdfc7cbe773c32e410af1782ab4803318848811ef4617a2a252d69d56" => :el_capitan
    sha256 "5a4a597b04d65b16c9d2b3de3acbe25902de8ad78d599e2d1f39520d0cfe4f56" => :yosemite
  end

  depends_on :python3

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
