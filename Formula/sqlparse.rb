class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/32/fe/8a8575debfd924c8160295686a7ea661107fc34d831429cce212b6442edb/sqlparse-0.4.2.tar.gz"
  sha256 "0c00730c74263a94e5a9919ade150dfc3b19c574389985446148402998287dae"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5917e87d404c93aa04ce10b94b1d036e1b7302b32e118931d86799022f22f671"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5917e87d404c93aa04ce10b94b1d036e1b7302b32e118931d86799022f22f671"
    sha256 cellar: :any_skip_relocation, monterey:       "2b655782b25db3c6de626342cc640acdf2226540935546a1e947c4bc064c969c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b655782b25db3c6de626342cc640acdf2226540935546a1e947c4bc064c969c"
    sha256 cellar: :any_skip_relocation, catalina:       "2b655782b25db3c6de626342cc640acdf2226540935546a1e947c4bc064c969c"
    sha256 cellar: :any_skip_relocation, mojave:         "2b655782b25db3c6de626342cc640acdf2226540935546a1e947c4bc064c969c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76b4d21dec27b2311986f15e9b279a8ac0cefe6bc5d91a94733ded3746cf3c90"
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
