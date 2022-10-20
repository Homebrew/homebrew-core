class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/ba/fa/5b7662b04b69f3a34b8867877e4dbf2a37b7f2a5c0bbb5a9eed64efd1ad1/sqlparse-0.4.3.tar.gz"
  sha256 "69ca804846bb114d2ec380e4360a8a340db83f0ccf3afceeb1404df028f57268"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59182d025638eb3e95eda5b0f2e15878d35b9d758d5bb38c4c8bcb908a2b6e32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59182d025638eb3e95eda5b0f2e15878d35b9d758d5bb38c4c8bcb908a2b6e32"
    sha256 cellar: :any_skip_relocation, monterey:       "5fa722a3eb224017a604ead376c986ead3b128a2edb8417d355d2970fce6a78c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fa722a3eb224017a604ead376c986ead3b128a2edb8417d355d2970fce6a78c"
    sha256 cellar: :any_skip_relocation, catalina:       "5fa722a3eb224017a604ead376c986ead3b128a2edb8417d355d2970fce6a78c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62aa5e4b12c27d5996b667aeecdbe1643c91ab6ed36777f6f898dc1bad0ed0a5"
  end

  depends_on "python@3.10"

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
