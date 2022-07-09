class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/57/31/f3367ef663034faa06ef7ff025123d983a6740ce87d87acdc14879071425/reorder_python_imports-3.6.0.tar.gz"
  sha256 "1d77fbd474098966f796ae1b69f04573c08ef87d357525beb8dc5194a9277ba3"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8a9f6a10d8e9da12a7900d831cf103eecace1a9c7c737b5bd7f64cb56e947c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8a9f6a10d8e9da12a7900d831cf103eecace1a9c7c737b5bd7f64cb56e947c0"
    sha256 cellar: :any_skip_relocation, monterey:       "ebe5769e179546e990c5ec2d18d20e34deec2ca428025a7914bc2385d890cf69"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebe5769e179546e990c5ec2d18d20e34deec2ca428025a7914bc2385d890cf69"
    sha256 cellar: :any_skip_relocation, catalina:       "ebe5769e179546e990c5ec2d18d20e34deec2ca428025a7914bc2385d890cf69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfde073d94a8ce483019473ca345606dbe5e0b184db47733fa3469152f1fca5d"
  end

  depends_on "python@3.10"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/5e/b1/5c8792dee3437a13d66e0518bcd6add8ec6f54a02c89ef3f14986a05016d/classify_imports-4.1.0.tar.gz"
    sha256 "69ddc4320690c26aa8baa66bf7e0fa0eecfda49d99cf71a59dee0b57dac82616"
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
