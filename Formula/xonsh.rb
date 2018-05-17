class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.4.tar.gz"
  sha256 "e303edfe0d1d65ec4f40af5b9f59b866709269cb917472f6362738d854f18765"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77a1dcd106bf071a30ff1484ff6b926937dd23a86dc4930a9fa4a4b29a8afcbc" => :high_sierra
    sha256 "dfb14f61bb6d4620d794597564aba4d1b5a0af18dfccf31ef4e66b7d176b28b4" => :sierra
    sha256 "f077c8748567af5e424fc52dcd6e972e0db75438365a6bcf82406fe1b84b3bd8" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
