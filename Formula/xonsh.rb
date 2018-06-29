class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.8.tar.gz"
  sha256 "77d8b64ddc600549fd073a3ead20c41e049e61e26e7f3337322449f7c9b11b71"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de7bbc1ac8c8fbcb40db60d15a54caf44ec4cf9ed9bebccc9389a933813d72ed" => :high_sierra
    sha256 "37e49d9a5edc6c0dd7fef59fbb88b771336985f986757fb8a041738445a5beeb" => :sierra
    sha256 "c64685f2ce97d37bd7e99f49dd4263810062fff67954ef7acba715440d6bcd90" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
