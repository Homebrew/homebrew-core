class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/67/4b/253b6902c1526885af6d361ca8c6b1400292e649f0e9c95ee0d2e8ec8681/sqlparse-0.3.1.tar.gz"
  sha256 "e162203737712307dfe78860cc56c8da8a852ab2ee33750e33aeadf38d12c548"

  bottle do
    cellar :any_skip_relocation
    sha256 "439ec9e76d4cb0bd66dde0e9bd3cf471d0c067ae19e5ccac0d8fcfaee0f08d62" => :catalina
    sha256 "a3f4a494651de7aca86d4743e9a54a2ba9209d4ca4785deaf21d6da51512ae63" => :mojave
    sha256 "73dbdb834b2d5cd10bf0629f7c7fe9631e3eda5b8a704c2b65e278f5ad94b741" => :high_sierra
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
