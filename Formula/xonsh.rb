class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.7.0.tar.gz"
  sha256 "75fef71b4367a4bef3e4a54cf83dbb9d78a2ea580c03398dc64b2af756813003"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "385928f402aa33b4bff469cdc4597f46ab01b4ddd2bf85ec4a2caa117999a036" => :high_sierra
    sha256 "d1df96f8b23d5a72c21cd50ad7fb0c3368708c41ac2e52d5b1b7a74010b4577b" => :sierra
    sha256 "f749c471663934a5cb3ecdd815c222f41e024963a72dd06bc504775b50fcb4d7" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
