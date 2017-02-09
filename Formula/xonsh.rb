class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.4.tar.gz"
  sha256 "878f57da4bbb8e67f0a83b910fd175f54c99bb1b5e652c7d039e72020c8d0e25"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "14b2a4cb0c1becc0afe38f4d8e727f45d68a4ae03baa90f7ab8611cb8e812fcc" => :sierra
    sha256 "23cebc1083fc63468d502ed037d4d042478c881096268e5930c731da5a832a76" => :el_capitan
    sha256 "006966dad3dda716cc529ef4883bbb4bcd5b8f67ee9043341db28248038fb123" => :yosemite
  end

  depends_on :python3

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
