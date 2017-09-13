class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.12.tar.gz"
  sha256 "d2a50d971aed321c2d9bc570878325b8f206ffd7f40cc6f757a0caf71faee75e"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "861ada2633afc69b6324d46680e020adaacd2581a73a394c4bdfeaf6cfd76d43" => :sierra
    sha256 "0cd6734053b749d50991c27a377284595460b2d94fd5c11e9d57d6ed52e48223" => :el_capitan
    sha256 "ea856ca47bc44ab2c6ae6f8fde3958c023d6bc61ee7eb303005cf750d115d290" => :yosemite
  end

  depends_on :python3

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
