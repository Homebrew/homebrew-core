class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/e1/0d/4e93c8e6d1001a75763f87d8f5ecda8ebc7f4aa2153dddfaf4ae8892821a/virtualenv-21.4.2.tar.gz"
  sha256 "38e6ee0a555615c0ea9da2ac7e9998fe8dc3b911dd33ad8eaad2020957653b0c"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "189f306aae31fee954c3a7df3513c13405f96f73f27a8ce73118b16c16ac7a58"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/b5/fe/997687a931ab51049acce6fa1f23e8f01216374ea81374ddee763c493db5/filelock-3.29.0.tar.gz"
    sha256 "69974355e960702e789734cb4871f884ea6fe50bd8404051a3530bc07809cf90"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/a6/12/38c1a0b1e64806780c9563e3fc9f6e472251839662587cfbe9bfaf2ae10a/python_discovery-1.4.0.tar.gz"
    sha256 "eb8bc7daad3c226c147e45bb4e970a1feb1bf4048ee178e6db59e197b8010ce3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
