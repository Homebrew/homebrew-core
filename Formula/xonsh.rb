class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.0.tar.gz"
  sha256 "7d63d040a6df8749480becab4b3bcb1c6589458bad272d5de06c6a063c06c5f1"
  revision 3
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca74bf037637441b357021ed7b7bca22a50f0fbb181f471f564900f8167da040" => :high_sierra
    sha256 "cfcb706aa68ed8bd1e29b01a1919cdc9e6b9673efb1e01732f59a0e66887c1d2" => :sierra
    sha256 "8f74f5fc5b9a5d1b0d11d8cb55f3d632d8a59ba3531370e0658cf5e2bc8a09a7" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
