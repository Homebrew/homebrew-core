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
    sha256 "4793150048d03d8fbc28d40482f4941bf75c7e25b55f6af22c33e9be6c617b01" => :high_sierra
    sha256 "e5a42b5da4d1aca63541f0e6422330ddaf15d9a55cbef35c9f9f7ca6f113f733" => :sierra
    sha256 "f95ff4dfbabdc802c792d4e2d448807acd33d13b4fcb2e3c93bc89e3517ab79d" => :el_capitan
  end

  depends_on "python3"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
