class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/33/d4/58a31918cbae4aea4a3c0f320fe94e616f0c0ca53c0d2fc87b578a8e1dc7/tox-4.67.5.tar.gz"
  sha256 "f1872e30d89c8d18cbdf3b93c4c7dc04d4f3928c0af413e9ae5b71ba3f1c438d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7dd4644e6e06a888e0d7d0662922980ef146cca22aaa8cbe7c7568c0e4237592"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7dd4644e6e06a888e0d7d0662922980ef146cca22aaa8cbe7c7568c0e4237592"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7dd4644e6e06a888e0d7d0662922980ef146cca22aaa8cbe7c7568c0e4237592"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ea49e769455e7531d256fdf7c85da6fffc3cfef57a02aad0c8991fd9eb82c898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ea49e769455e7531d256fdf7c85da6fffc3cfef57a02aad0c8991fd9eb82c898"
  end

  depends_on "python@3.15"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/40/3a/bce69b9ecf4658dcd3599abe5122a9031386f8f94bd85c6525fca9109db7/cachetools-7.2.7.tar.gz"
    sha256 "e2154c809ce9e1247120258c36821467597b5663d44c3255a9790785f23c2b1e"
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
    url "https://files.pythonhosted.org/packages/aa/4b/2320d9fa03b65b4beb43b521fe1b12b7f87ab91ee42de3a286075016d205/filelock-4.2.5.tar.gz"
    sha256 "37d8fa4f8b5e9233612e68ab23bf64cae41771322c8797361088ae2895b12894"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/40/28/1c058a9143d2304b3078f8dadcbb9dc27f7d3581b5d05157c84869c4cc0d/platformdirs-4.14.0.tar.gz"
    sha256 "83f009c1e8c5fc36869b5171755b291887bd2cade7965233cdfabd23d754720b"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/a6/af/5ac3c74655469fd52c6d496d728a85e5db454abb15682be5e620735a2349/pyproject_api-1.12.2.tar.gz"
    sha256 "ad2a72516abcc950877222e9eff760c9120d2086f0d9fce6aef4f16985a3e946"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/86/15/0405206e0cfe0c14b91ac038d31f30d1dd78139b3b2a285e6be41bf6e5af/python_discovery-1.9.0.tar.gz"
    sha256 "88beb57e51b919c30f303b053ec41359298ca349192035b0a802c76347ae96d7"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/38/9e/40c7098240cedd3a2f32e42a74b35c4563c617fdd7e41ae6268d4fdd8915/virtualenv-21.15.2.tar.gz"
    sha256 "dbd886e6e5689eb4dde6a9bbc478ad14b4fc8ed0852690d8273ccfb8c467f635"
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
