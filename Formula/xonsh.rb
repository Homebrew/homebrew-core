class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.7.1.tar.gz"
  sha256 "87a9407b90e297d57fbb92a0c1e675cf5a10a65410c05902b90e77c0345b6887"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "385928f402aa33b4bff469cdc4597f46ab01b4ddd2bf85ec4a2caa117999a036" => :high_sierra
    sha256 "d1df96f8b23d5a72c21cd50ad7fb0c3368708c41ac2e52d5b1b7a74010b4577b" => :sierra
    sha256 "f749c471663934a5cb3ecdd815c222f41e024963a72dd06bc504775b50fcb4d7" => :el_capitan
  end

  depends_on "python"

  def install
    venv = virtualenv_create libexec, "python3"
    venv.pip_install ["ply==3.11", "prompt-toolkit==2.0.4", "Pygments==2.2.0", "setproctitle==1.1.10", "six==1.11.0", "wcwidth==0.1.7"]
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
