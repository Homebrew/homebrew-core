class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.6.tar.gz"
  sha256 "c54a27fb4d4f57152788797005ba339776e6bf4ea70fc231f2101105f7081eaa"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "f7570d498c07a77279f54f1401270fc1e93b4c01e3d758d15fdbaa55507e0e97" => :sierra
    sha256 "c65cf1b579f77d31da059f50702d5f2731a58e37ff0cf57bbac7273f43314c6a" => :el_capitan
    sha256 "49f73389f6bedfa3408827a5103c9b117a6a006a14dddd7deb7ce68481cb8f66" => :yosemite
  end

  depends_on :python3

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
