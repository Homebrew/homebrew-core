class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.17.0.tar.gz"
  sha256 "8e52aa79cee732158511603be23b449b57f6fb858ce331968c0dccdfa51130be"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00a98402daca5c8bb611e71c2bbf1fe916989e8b58e62c2c6b7521b49fe1c71c" => :sierra
    sha256 "562aececf2000bd422e05ef9b5a968081d0b51e948ff588a4ae0b84c0bb6e6a7" => :el_capitan
    sha256 "d47c198892d27a63d93d0892403494bdbe7f98b83abbac58878b4e87ef433d71" => :yosemite
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
