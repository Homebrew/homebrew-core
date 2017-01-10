class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/55/ce/3944e990b03f80f36f0050b407ad46cde192a210d473f0d705b554bddd1d/sqlparse-0.2.2.tar.gz"
  sha256 "d446296b2c26f9466860dd85fa32480bec523ab96bda8879262c38e8e8fbba21"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a42b6775a9f271af9c6d0689b21018e49456bc6d155df6565af9836fc281f7a" => :sierra
    sha256 "b00598d85a30851dc3423224490161e4505d700f76fb9e94f7734a46a8670b2c" => :el_capitan
    sha256 "6bf8422914fd86c7ec67be7f2cc968827869aa38b854a5d3edcef6fcb7e0e6f3" => :yosemite
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
