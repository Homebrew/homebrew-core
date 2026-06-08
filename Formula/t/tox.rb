class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/79/5b/4f09156a3f7bf3c4fa23212717f097c59126d81e2c557e6fd872a62db38a/tox-4.55.1.tar.gz"
  sha256 "0678fbf26dd5b559b1ef128fa4388325920219322ebc8cc5f3497627c00f4472"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0b80deef08fb3592f7710c2f0b3e6979bf2c80994e6f2516b13571c2fc3075f6"
  end

  depends_on "python@3.14"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/f4/8b/0d3945a13955303b81272f759a0331e54c5c793da455e6f5706b89d2639c/cachetools-7.1.4.tar.gz"
    sha256 "437f55a4e0c1b01a4f3077cc470e6991d47430970e36fbcb77e2be0df4fc1cd6"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/86/b2/d6fc3f2347f43dada79e5ff118493e8109c98400a0e29a1d5264a3aa479b/distlib-0.4.1.tar.gz"
    sha256 "c3804d0d2d4b5fcd44036eb860cb6660485fcdf5c2aba53dc324d805837ea65b"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/1f/f9/f38573ed5844586db374d085911740a501ccfa373b455fc9413f09f85237/filelock-3.29.1.tar.gz"
    sha256 "d97e6b1b9757569626c58caa07dc4beb1613f4a2938b1e8cc81afca398906c9e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/62/62/0fe346fe380b1aafaf819c8cb195d3241bb4f355f908e6339814131a830b/pyproject_api-1.10.1.tar.gz"
    sha256 "c2b2726bd7aa9217b6c50b621fef5b2ae5def4d55b779c9e0694c15e0a8517ba"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/a6/12/38c1a0b1e64806780c9563e3fc9f6e472251839662587cfbe9bfaf2ae10a/python_discovery-1.4.0.tar.gz"
    sha256 "eb8bc7daad3c226c147e45bb4e970a1feb1bf4048ee178e6db59e197b8010ce3"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/e1/0d/4e93c8e6d1001a75763f87d8f5ecda8ebc7f4aa2153dddfaf4ae8892821a/virtualenv-21.4.2.tar.gz"
    sha256 "38e6ee0a555615c0ea9da2ac7e9998fe8dc3b911dd33ad8eaad2020957653b0c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(Formula["python@3.14"].opt_bin/"python3.14").to_s.delete(".")

    system bin/"tox", "quickstart", "src"
    (testpath/"src/test_trivial.py").write <<~PYTHON
      def test_trivial():
          assert True
    PYTHON
    chdir "src" do
      system bin/"tox", "run"
    end
    assert_path_exists testpath/"src/.tox/py#{pyver}"
  end
end
