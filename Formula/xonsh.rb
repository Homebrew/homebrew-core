class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.7.0.tar.gz"
  sha256 "75fef71b4367a4bef3e4a54cf83dbb9d78a2ea580c03398dc64b2af756813003"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b418cdf63de92d05ca856ba18fcc6375ca78044163e988fd9c7117b20fa7a3d" => :high_sierra
    sha256 "e99de6b9edae17805e46b842a5c84b92eb6e3f4df94f4c52990ee46fb889c41c" => :sierra
    sha256 "3bc0c6daeee3a9977472b6a09b3e0c1d057f43258bda4a32b8deca38d76c92b6" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
