class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/e5/40/edede8dd6977b0d3da179a342c198ed100dd2aba4be081861ee5911e4da4/sqlparse-0.5.3.tar.gz"
  sha256 "09f67787f56a0b16ecdbde1bfc7f5d9c3371ca683cfeaa8e6ff60b4807ec9272"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "27c0cee7eb47fbe549b5cc018c08d715e4124b723cfb5a472f2099ea54f28e08"
  end

  depends_on "python@3.13"

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
