class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/45/67/14bdaeff492e6d03a055fe80502bae10b679891c25a0dc59be2fe51002f8/sqlparse-0.2.3.tar.gz"
  sha256 "becd7cc7cebbdf311de8ceedfcf2bd2403297024418801947f8c953025beeff8"

  bottle do
    cellar :any_skip_relocation
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
