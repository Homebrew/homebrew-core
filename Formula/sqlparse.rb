class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/79/3c/2ad76ba49f9e3d88d2b58e135b7821d93741856d1fe49970171f73529303/sqlparse-0.2.4.tar.gz"
  sha256 "ce028444cfab83be538752a2ffdb56bc417b7784ff35bb9a3062413717807dec"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "444a821e9f86c2c006adf21fd8a7634fa2b29297048645369ff277699cb380a9" => :catalina
    sha256 "0f61f9a78b26948c3c8d5fcc28a0674daa03e1cc42f12a60141e635cda39f057" => :mojave
    sha256 "ad46edd169ea0545a88bec251cbd87619b6777dd166fe382fa126d9be70d06fe" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    expected = <<~EOS.chomp
      select *
        from foo
    EOS
    output = pipe_output("#{bin}/sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end
