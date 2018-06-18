class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.7.tar.gz"
  sha256 "1ff04ac5aa8a9cfc6d88303bcf9ee304721be27e77ce14978804d9b52f3a1d3c"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5d0fa80ffcf417374a1dda1b1652c8da378f54d4bd8269e3f4638202406e31d" => :high_sierra
    sha256 "16d711d47e9c84483a86d499ab90e8d3d9c11a6fada10ce650d36e85a4f73e03" => :sierra
    sha256 "024b243f0619ab8658620246717e4179963a6e9c070388fe6ecfc5c0e7722003" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
