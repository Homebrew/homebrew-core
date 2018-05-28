class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.5.tar.gz"
  sha256 "fc5e320a504d9c1b0d9862b39990a36c56bf56537ab328cd57ae9230bee48ff6"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a68eeb7cbde4e8f3e79a434eb630b3431ea29a8a5ac99a635fb97e1d948bc02" => :high_sierra
    sha256 "74ea44353a993c06e1d33121052fe8a2771a6cef37f64b4399bb7c6e9b66f1e1" => :sierra
    sha256 "9c2294f22a5c46a875d3c18e5dc33caf5be543da53d6d0ede9c96391cfb3788e" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
