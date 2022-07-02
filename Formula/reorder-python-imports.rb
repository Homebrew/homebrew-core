class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/52/c0/319fb92c3784fcf25a000d211cc0bc343d9d1c220b5b8f5a9d66bafb3c0e/reorder_python_imports-3.2.0.tar.gz"
  sha256 "27396162d0262c8680f9a94164bf9eb2914fde09784d97b43978b41aef52d0da"
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

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/1a/85/401a59cefb79e3446876a479dc2a83de5795915beb9e197b35c1904e374d/classify_imports-4.0.1.tar.gz"
    sha256 "cfee9a3145b9bb4a772ed91047e1710da81e8befa135fdea4bb19c5469a3d5da"
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
