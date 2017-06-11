class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.5.12.tar.gz"
  sha256 "d2a50d971aed321c2d9bc570878325b8f206ffd7f40cc6f757a0caf71faee75e"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "322ae8ae1f252d658e9ebd2ca012d909f19617ac107975645e83d5528108d87b" => :sierra
    sha256 "609fee07a986eb48199c8b6a14a65e88f20f979ffc09bbe2073c0cca1fae8dd2" => :el_capitan
    sha256 "0bf777613a977e3417cd895d1da13ea54d2a934ebc22c63e41184b0cb5bb5a90" => :yosemite
  end

  depends_on :python3

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
