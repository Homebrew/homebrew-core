class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/32/fe/8a8575debfd924c8160295686a7ea661107fc34d831429cce212b6442edb/sqlparse-0.4.2.tar.gz"
  sha256 "0c00730c74263a94e5a9919ade150dfc3b19c574389985446148402998287dae"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1a984ac437bd907f5eac3e62965dd8cf78859965304d74cab2c9c240d9c7d17a"
    sha256 cellar: :any_skip_relocation, big_sur:       "361c451cebe6f78c03e55929ed30d1d98781025e65f5bad09d2f41d55d15a52d"
    sha256 cellar: :any_skip_relocation, catalina:      "361c451cebe6f78c03e55929ed30d1d98781025e65f5bad09d2f41d55d15a52d"
    sha256 cellar: :any_skip_relocation, mojave:        "361c451cebe6f78c03e55929ed30d1d98781025e65f5bad09d2f41d55d15a52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "180b65725243b7b0746ce80b98d4e4d3522ed720e38f6f02d0c6f98a849e9a33"
  end

  depends_on "python@3.9"

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
