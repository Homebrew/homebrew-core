class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/67/4b/253b6902c1526885af6d361ca8c6b1400292e649f0e9c95ee0d2e8ec8681/sqlparse-0.3.1.tar.gz"
  sha256 "e162203737712307dfe78860cc56c8da8a852ab2ee33750e33aeadf38d12c548"

  bottle do
    cellar :any_skip_relocation
    sha256 "a886da74810f4112ac16b08840eac4ebd3ccd3daf5b7219ba1ad84d2981b8478" => :catalina
    sha256 "cbd26ba6872f20f79ccb9545f2329697e3f2611c124040502cd751fa4efd5432" => :mojave
    sha256 "c3e7934f912db3b38d16bd6adb86a496568040bcbd66f646822679b233d3d193" => :high_sierra
  end

  depends_on "python@3.8"

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
