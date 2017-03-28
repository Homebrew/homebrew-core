class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.9.tar.gz"
  sha256 "83ed3ab9e210d2f9e492432dbeac872a40df991a0974ea633a9f3ce99937195b"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "9c207259216e99199dc871d387dd0a664091740206a32e69677106d0e846d84c" => :sierra
    sha256 "79fcffbee3dfeea1c3f008c9957f8658a97d71f9bc222f2b7f2478f4a75b7d4b" => :el_capitan
    sha256 "7dc9d138a4a975040201e3ab3e718917aec773c1b923df5879adf6f1d66fd367" => :yosemite
  end

  depends_on :python3

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
