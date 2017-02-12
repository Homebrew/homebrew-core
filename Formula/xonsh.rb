class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.4.tar.gz"
  sha256 "878f57da4bbb8e67f0a83b910fd175f54c99bb1b5e652c7d039e72020c8d0e25"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "c32d81bb9ddf9dac9a023ae622a39b1c112ae59c553c867f48a8110ece3351ca" => :sierra
    sha256 "66064b2fe9f2a7b0318c0e5b87b51ca6c3acba7f606eeca81a17397ab49c2dc6" => :el_capitan
    sha256 "d8011d9302054ae97027f7f67ca054f4c798f4a8a887cd85271f9c097e8bb7ea" => :yosemite
  end

  depends_on :python3

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
