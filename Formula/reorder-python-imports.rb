class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/0f/09/03893c8de481420a71476b47ca5e1a09a9aba111802de7ad24957a72d129/reorder_python_imports-3.1.0.tar.gz"
  sha256 "6b7a810ee77a9be0e646033d034ce02457e32597c5f48e5faec1866ca9eb4957"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fbc532def7c000bd395760b26372aeed401202ad4edaa98a7a109d53400116c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fbc532def7c000bd395760b26372aeed401202ad4edaa98a7a109d53400116c"
    sha256 cellar: :any_skip_relocation, monterey:       "a5fcdb7eea5268e819e632bf8d26a1552e60e7470461e7f1350e4a3e5df146ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5fcdb7eea5268e819e632bf8d26a1552e60e7470461e7f1350e4a3e5df146ea"
    sha256 cellar: :any_skip_relocation, catalina:       "a5fcdb7eea5268e819e632bf8d26a1552e60e7470461e7f1350e4a3e5df146ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70375e2797be7317f5b02c454c5eab397051b0dfcdc3380f836f88c104cd6bb1"
  end

  depends_on "python@3.10"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/8a/f1/2cc8c8b9e4de77ee1b3ba889eeafb68ab0b38b28d856b48b821b9d361f41/aspy.refactor_imports-3.0.1.tar.gz"
    sha256 "df497c3726ee2931b03d403e58a4590f7f4e60059b115cf5df0e07e70c7c73be"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      from os import path
      import sys
    EOS
    system "#{bin}/reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}/test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end
