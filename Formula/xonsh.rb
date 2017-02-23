class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.6.tar.gz"
  sha256 "c54a27fb4d4f57152788797005ba339776e6bf4ea70fc231f2101105f7081eaa"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "fd9f7cbafb6b0759c3e6c7f1f419906e1eae379eeffa599113ed056e7dc353a2" => :sierra
    sha256 "1b42ea2ad940257c5b6e771ed0aaa9ccdeb3b3fe263b47b581a8fc6c295b33fc" => :el_capitan
    sha256 "c97ba9bbbbfedb32788a7c62543cf1da9cf85de6b161995ce234c073c0fbcc0a" => :yosemite
  end

  depends_on :python3

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
