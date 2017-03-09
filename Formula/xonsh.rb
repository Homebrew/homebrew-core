class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.8.tar.gz"
  sha256 "bf5632ce1132616778d2821d660dc6508ecbb93c65da80640d08f6b9ddc87ed9"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "2a13124f9dbda8620024dcaa484a8770f2de556de78736e38cb550dfa0b611f0" => :sierra
    sha256 "c3c667a7bc5f15a0fc67b9f664939b1632bff314808cf0021b6e4f824ceaafbf" => :el_capitan
    sha256 "e10642eb1e1dec6bb73ce142a4b767c1fc4fa08424347c926d3e258d7de0e706" => :yosemite
  end

  depends_on :python3

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
