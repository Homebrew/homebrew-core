class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/23/98/f2c8c5ee8cc406e1352b5aaad7b2f927b9a5a081ee2050eb302f5ec1b780/reorder_python_imports-3.9.0.tar.gz"
  sha256 "49292ed537829a6bece9fb3746fc1bbe98f52643be5de01a4e13680268a5b0ec"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e845aa0e5a6c2883566796d00f932350f988968c04ba4980e594408d811a374b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e845aa0e5a6c2883566796d00f932350f988968c04ba4980e594408d811a374b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e845aa0e5a6c2883566796d00f932350f988968c04ba4980e594408d811a374b"
    sha256 cellar: :any_skip_relocation, ventura:        "b4f03287329d4021b1dddc22c05e0424c357ec794fbe9899fa66c8d35781db25"
    sha256 cellar: :any_skip_relocation, monterey:       "b4f03287329d4021b1dddc22c05e0424c357ec794fbe9899fa66c8d35781db25"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4f03287329d4021b1dddc22c05e0424c357ec794fbe9899fa66c8d35781db25"
    sha256 cellar: :any_skip_relocation, catalina:       "b4f03287329d4021b1dddc22c05e0424c357ec794fbe9899fa66c8d35781db25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d95bd5815215402bf15e21cf741e8979cb0d45a288ab165b3fa4cb96f11739d6"
  end

  depends_on "python@3.11"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/7e/b6/6cdc486fced92110a8166aa190b7d60435165119990fc2e187a56d15144b/classify_imports-4.2.0.tar.gz"
    sha256 "7abfb7ea92149b29d046bd34573d247ba6e68cc28100c801eba4af17964fc40e"
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
