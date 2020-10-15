class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/67/4b/253b6902c1526885af6d361ca8c6b1400292e649f0e9c95ee0d2e8ec8681/sqlparse-0.3.1.tar.gz"
  sha256 "e162203737712307dfe78860cc56c8da8a852ab2ee33750e33aeadf38d12c548"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "51938899cca31fea46f4b8ca06ed6ea730b3fa9f8ccf3b05c0d5ae01a58b4bac" => :catalina
    sha256 "2d52f1ea77ef4b97c95a5dc77097c324f950c9ec0fe370afd795222a41d8b6a8" => :mojave
    sha256 "60f79b4eca3f227ee975ab3a464f772b7f3e6c955aca664b891d978f5c9dd0d7" => :high_sierra
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
