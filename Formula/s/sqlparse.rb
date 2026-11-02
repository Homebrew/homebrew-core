class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/7e/e0/361c764ea58cc1a75f7b4b424a74b08449db8bfa5e9199c7275999fdd1b9/sqlparse-0.6.1.tar.gz"
  sha256 "ca722573f848ff2d30e40ea30f53a104b7dea7635ea9285891263eb2c58fb6e7"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2ece9a8c36e4fc5f3a4d1ba629a2d01399e2c0cebe49b66dfbd0a6d95e7d4555"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
    man1.install "docs/sqlformat.1"
  end

  test do
    expected = <<~SQL.chomp
      select *
        from foo
    SQL
    output = pipe_output("#{bin}/sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end
