class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.10.tar.gz"
  sha256 "b15ec7488741968a9daaf259e8ce069a7d3aad9563e4c57554743872d6962361"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e11db164ea8d7896c20c2105379b7ee87446b473dbc7f439864bfa60fca3b4e3" => :high_sierra
    sha256 "36aa4b5df058f3fb6aba7b4143014b66c7d2138a4901956526c5815ae88b6cae" => :sierra
    sha256 "01bf926cbdcfc8efe00a8a1c7b7e6b426f93487876784da7bd930fdd8911f2f0" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
