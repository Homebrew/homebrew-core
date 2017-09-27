class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/79/3c/2ad76ba49f9e3d88d2b58e135b7821d93741856d1fe49970171f73529303/sqlparse-0.2.4.tar.gz"
  sha256 "ce028444cfab83be538752a2ffdb56bc417b7784ff35bb9a3062413717807dec"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a658338e493383550813c4065173cc6ecbb2a6d4e4e11e2855a7a7f8393bc33" => :high_sierra
    sha256 "71e3a2ec0d8e4768883630a863e88a39c0b8cd122ff9d0d720df5f2b5fdf82c6" => :sierra
    sha256 "ce87e30708dc8b0cfb7b0b3c69a49e230375ee67eadab2b7bf7524f87fd50976" => :el_capitan
    sha256 "7a152da6d6a9520b05f6784db3f2867580a3fc16dd20c99185cc5012771534d4" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    virtualenv_install_with_resources
  end

  test do
    expected = <<-EOS.undent.chomp
      select *
        from foo
    EOS
    output = pipe_output("#{bin}/sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end
