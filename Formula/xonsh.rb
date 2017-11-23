class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.0.tar.gz"
  sha256 "7d63d040a6df8749480becab4b3bcb1c6589458bad272d5de06c6a063c06c5f1"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a36969d17d198ecc0a9671781f3ff4eadb6a4bf2a2ea43a57d2e7760ccbea9a" => :high_sierra
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
