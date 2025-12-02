class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/18/67/701f86b28d63b2086de47c942eccf8ca2208b3be69715a1119a4e384415a/sqlparse-0.5.4.tar.gz"
  sha256 "4396a7d3cf1cd679c1be976cf3dc6e0a51d0111e87787e7a8d780e7d5a998f9e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b4252f17097b70bb6f13017e795742ee985d9d3d63a76c9cdfe9ee42bbb07ea"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
    man1.install "docs/sqlformat.1"
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
