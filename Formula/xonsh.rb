class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.4.6.tar.gz"
  sha256 "f9635732cb73fbe3bc7ea9aefab87e0fec04b5105932bf3cf44ec0eeef1a146c"
  revision 1

  head "https://github.com/scopatz/xonsh.git"

  bottle do
    sha256 "a1dd6735e719403974c4864440c35cc5414af09d18bb60a98a6ff122685d4497" => :sierra
    sha256 "b1d896e120e47de8939f610578b3d99b5676a7501e67b18f94997e517542e3c1" => :el_capitan
    sha256 "0f4dc449fd4d3e6761d894d5524e016f7243453b5c99ed750eb7d63abb9caf87" => :yosemite
    sha256 "87522c9856711b03ae11874789dc8be3083f4698b4325c2294e41fd841593637" => :mavericks
  end

  depends_on :python3

  resource "ply" do
    url "https://pypi.python.org/packages/96/e0/430fcdb6b3ef1ae534d231397bee7e9304be14a47a267e82ebcb3323d0b5/ply-3.8.tar.gz"
    sha256 "e7d1bdff026beb159c9942f7a17e102c375638d9478a7ecd4cc0c76afd8de0b8"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
