class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.0.tar.gz"
  sha256 "7d63d040a6df8749480becab4b3bcb1c6589458bad272d5de06c6a063c06c5f1"
  revision 1
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4a161f4a5d52c1889472d1c899dc468f38b5e547631acbc478b0c70042476c5" => :high_sierra
    sha256 "cb6f319be7bbaa573329734093470ab676222e9ac76e548e121775fbb2da26c7" => :sierra
    sha256 "9583716f1864b9c4b5f3cb4bb3130ba06412840eb634f51a3c5be41ef0f2d0a4" => :el_capitan
  end

  depends_on "python3"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
