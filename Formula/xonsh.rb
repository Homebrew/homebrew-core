class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.2.tar.gz"
  sha256 "b5c221476d02b013965b715950b4b9ee8c8cec423db82e219a09d69215d4b0a4"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49d7592f793791ab573dc072d02fc1e4d8e9115f50500e55b38e7412a98decb4" => :high_sierra
    sha256 "1bc169097c1f1adefd86bb681b22020f0c83f79aa0442ff492d55c17f3e30000" => :sierra
    sha256 "172d779cb699d5c433217724cb7f61a8d9219649da36c89ff70fe33a8dc7540f" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
