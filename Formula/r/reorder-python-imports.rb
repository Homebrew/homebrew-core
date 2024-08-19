class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder-python-imports"
  url "https://files.pythonhosted.org/packages/ae/f8/63ecf759c9149d7d7a8b612ebfe74901164dde9adcb1c40975ddc713db1c/reorder_python_imports-3.13.0.tar.gz"
  sha256 "994235fe9273373af6df7290de6a362a2426eb9bb800f5197367fe54b081f4d9"
  license "MIT"
  head "https://github.com/asottile/reorder-python-imports.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2184a6a4047d37b0c9cb152b9fc78a902928c1eb21acc76dbbeb3a3b964eafe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2184a6a4047d37b0c9cb152b9fc78a902928c1eb21acc76dbbeb3a3b964eafe8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2184a6a4047d37b0c9cb152b9fc78a902928c1eb21acc76dbbeb3a3b964eafe8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2184a6a4047d37b0c9cb152b9fc78a902928c1eb21acc76dbbeb3a3b964eafe8"
    sha256 cellar: :any_skip_relocation, ventura:        "2184a6a4047d37b0c9cb152b9fc78a902928c1eb21acc76dbbeb3a3b964eafe8"
    sha256 cellar: :any_skip_relocation, monterey:       "2184a6a4047d37b0c9cb152b9fc78a902928c1eb21acc76dbbeb3a3b964eafe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "453f41a6a7922df6dba675524704b362bf71215209efc7c9f6da0ddc4469caf6"
  end

  depends_on "python@3.12"

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
    system bin/"reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}/test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end
