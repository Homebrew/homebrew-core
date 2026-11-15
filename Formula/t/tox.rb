class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/da/4e/703160b580afbecef60e764708adbbf37f102aadfcbce9bb122e924e994d/tox-4.67.13.tar.gz"
  sha256 "9f70b44ca2e31d91d8fe2e2917f505554950adc3961c0ee70bb42db16d903f62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29303f761f7e5ba2d38bd6875c88e2b2c0b27c814725e017bb1012f4a87cec46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29303f761f7e5ba2d38bd6875c88e2b2c0b27c814725e017bb1012f4a87cec46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29303f761f7e5ba2d38bd6875c88e2b2c0b27c814725e017bb1012f4a87cec46"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3ce2ad02c7798da18ac1555f6ac86c8bbb213d33bb4e02f9e6ed12cbac6490f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d3ce2ad02c7798da18ac1555f6ac86c8bbb213d33bb4e02f9e6ed12cbac6490f"
  end

  depends_on "python@3.15"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/5f/6b/6c1553e1e8f672f9423344a1915aad1537439ad3d14a3fbc1a02159cfd94/cachetools-7.3.0.tar.gz"
    sha256 "3f63fc208410f0c3a3b37883c4903ecdacd6f0b259134e6d2e82debd5b2e01de"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/a3/1d/d730c664fcb4f1d264a722722a3134cf0881854f73c1fd58abf87572f232/filelock-4.2.9.tar.gz"
    sha256 "96530b7c538d4ea08493ab067247aab7948c54d8cd622cce711c97cccc5d9896"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/7b/10/806fcc3ddb672150199bf769af4c90016654829b02f039c3d58f23a08fb7/pyproject_api-1.12.4.tar.gz"
    sha256 "79d0584a851fc945150715fa7871b0d72f48000e848b2298193d160cc18b3c89"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/68/55/70b46fae646bc6f5cb5e82569949d925cff1c7b5ce20ec4a11e0d977f8c6/python_discovery-1.9.5.tar.gz"
    sha256 "86279f5d2728bc067de28b7ddc571be2eacc2ae0e7048f8629d2481a0f8848a2"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/69/74/745e612b69ad14a534b7bc233c4574b968eb2c21a276ea172e8f0fc13f51/virtualenv-21.15.5.tar.gz"
    sha256 "fb869ea32930530ccc87549877b53268c2a4d4a7d7f2c384042eca05170350e6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(python3).to_s.delete(".")

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
