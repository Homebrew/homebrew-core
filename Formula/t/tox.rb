class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/aa/55/f2961e596aa9cf66221c1d28eefb8cf7b02b59615cf192880a8ba738931c/tox-4.67.9.tar.gz"
  sha256 "053f1f66c2747339e75ffd68a1aae67115b2d83358764b9e095c07e845faf13d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "049dfc722fa0de53f781be9064f359875b8abface96ef279ff04acb95b0c7a04"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "049dfc722fa0de53f781be9064f359875b8abface96ef279ff04acb95b0c7a04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "049dfc722fa0de53f781be9064f359875b8abface96ef279ff04acb95b0c7a04"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "83fa9a471a21c1050bae0abdddefa3cd1aefa45b2bea9f6b11c8eb6f1205c052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "83fa9a471a21c1050bae0abdddefa3cd1aefa45b2bea9f6b11c8eb6f1205c052"
  end

  depends_on "python@3.15"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/93/6f/faa5e0606769105e70e0478031a8f9a6b729e329f42ce2462585c6d9aa52/cachetools-7.2.8.tar.gz"
    sha256 "3f9b146b2160975da273e7c23ec882f3996b65df608150d52083c07de0682075"
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
    url "https://files.pythonhosted.org/packages/c8/51/6619729344deb33a55ead1fbf50ac6435f43e33d6d57e56acd1495b24233/filelock-4.2.8.tar.gz"
    sha256 "23df640ac0c3351f8d15c9739072d63be9078758b7d102a2183277ceb96605a3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/a1/f1/602599e5879fce55f44b8021d28bd3817d87198a6be63e5c9d7e31891f0d/platformdirs-4.14.4.tar.gz"
    sha256 "edb4a4aea570d69eb83e6b0973b588bbf868fb0dde2894106d6667739f017751"
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
    url "https://files.pythonhosted.org/packages/0f/d7/1e94df7d1636bf00b9f261bf88a4adc0414f14931ff60511eb0f34c250d1/python_discovery-1.9.4.tar.gz"
    sha256 "c01b45fe515c1d268b57c57d554bb0e1d320b8e9eb5490bb2f4f577be26e4380"
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
