class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/73/82/dfa23ec2cbed08a801deab02fe7c904bfb00765256b155941d789a338c68/sqlparse-0.5.1.tar.gz"
  sha256 "bb6b4df465655ef332548e24f08e205afc81b9ab86cb1c45657a7ff173a3a00e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ac1ed03b6d3ca689ad633ff3fffc2b4be12312dc38617d1a8ac40f8081e11fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ac1ed03b6d3ca689ad633ff3fffc2b4be12312dc38617d1a8ac40f8081e11fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ac1ed03b6d3ca689ad633ff3fffc2b4be12312dc38617d1a8ac40f8081e11fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ac1ed03b6d3ca689ad633ff3fffc2b4be12312dc38617d1a8ac40f8081e11fd"
    sha256 cellar: :any_skip_relocation, ventura:        "5ac1ed03b6d3ca689ad633ff3fffc2b4be12312dc38617d1a8ac40f8081e11fd"
    sha256 cellar: :any_skip_relocation, monterey:       "5ac1ed03b6d3ca689ad633ff3fffc2b4be12312dc38617d1a8ac40f8081e11fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8de1c1b68822f597b5c3539c078346097bfe91fa73b2362b1b2a1a238e41af34"
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
