class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/79/3c/2ad76ba49f9e3d88d2b58e135b7821d93741856d1fe49970171f73529303/sqlparse-0.2.4.tar.gz"
  sha256 "ce028444cfab83be538752a2ffdb56bc417b7784ff35bb9a3062413717807dec"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3563df512a09a0719564b8c3a30db9e95a92bd809680f2fac548473ea9cbb748" => :catalina
    sha256 "608b6e92c003594456ab481c7dcdbd876d402fd96c97ceeaba0dcf5853648319" => :mojave
    sha256 "477a0a456ef2dd768bbda3324e9b2fea70b9359402423051f93a5d7e4a6318dd" => :high_sierra
    sha256 "9c77ae1a2ca8a0cfe79197762b9c60be451b827cf72f616542547ec280b3acb3" => :sierra
  end

  depends_on "python"

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
