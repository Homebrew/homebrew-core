class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/8e/8a/0a388c66c58bd5afa9a8f1fa8c28ec2aab3da2f9f397265cc3ebc9d526ad/reorder_python_imports-3.11.0.tar.gz"
  sha256 "b39776d1f43083f6f537d14642a9b70ea6d7aa91a013330543d2ae7d12e2e7e2"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44d27fc5bbf3addef5890df0afbc42df36ff2ea2ea0a69bb9438563bea142e2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b524242a72ee2c9a2bc8df0c605f33ad16841fdf61ec011eee0bb58bd4f88634"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80d848ca5e778047046932f8463d4508e5aaf211aaa784a6eda4c5390b1a4a79"
    sha256 cellar: :any_skip_relocation, ventura:        "df7ccb1fdc6de5e13430ac4b4b41c96f903242a520a8a16f8e85cd29659b32f5"
    sha256 cellar: :any_skip_relocation, monterey:       "75db721df6b20dc6297d8e672d91ede5a3c36c2d2021c2436077cdb56e99343d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f428ec3e9ddaa9a574d8957425386b2736cb26633fa490e8db667d9421ccfb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13df84fa6f80a6f330b9618a465b070b26dad233e6f058f98cd259fca7020c0f"
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
