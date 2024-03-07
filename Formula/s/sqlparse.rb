class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
  sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e51ab36ad42a6c5a7cc76fb89836593e683b9ef79de1ecd50470b8f4b276dc0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3344f8769f138c839aa74be3e59a6397d5bbf1eb316b9ecce1a370e0765ba294"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dd5dd753180531424a44c90979a31d9951b2315d6c041bc9c4e1656f0fc9ff7"
    sha256 cellar: :any_skip_relocation, sonoma:         "100209300700c9419cf6b643d1853ad5ef5eb8a3e968f90645a49fa2ba61ad12"
    sha256 cellar: :any_skip_relocation, ventura:        "94e2fe9474b842fbf20b9f31f8613cbce9112e8519b3eba8edf22358b1f27b69"
    sha256 cellar: :any_skip_relocation, monterey:       "f56530a62ffd0e7e53119318e135ea118dadf1329f0cc55b5871ea99a142ce03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eae399addb6d8d3ec1a6d7ed91b74284bfbaee35966531abf8021e974cbf5be"
  end

  depends_on "python@3.12"

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
