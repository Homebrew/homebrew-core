class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/63/6e/677274ae411fa13f5c2ea5c633a6abfa0886e949bd2ef53c7e564a0b0b2e/tox-4.67.1.tar.gz"
  sha256 "a68602f64421b199016127364ee47347b958391d19c2b2e53fe95673a8fe98e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1039afcbcc162cd6d4786c1263fc076385f4bad297d4b8e2c25d29aa26b1b602"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1039afcbcc162cd6d4786c1263fc076385f4bad297d4b8e2c25d29aa26b1b602"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1039afcbcc162cd6d4786c1263fc076385f4bad297d4b8e2c25d29aa26b1b602"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "283db365420d1dcd37b3561f532184eeeaa152c5d815852804fe4436e8fc2be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "283db365420d1dcd37b3561f532184eeeaa152c5d815852804fe4436e8fc2be8"
  end

  depends_on "python@3.15"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/09/88/27fe0785c7a9aa285c753db0b4ea967adbf76128fede66379c35a4b8d054/cachetools-7.2.3.tar.gz"
    sha256 "e6fafd06de4a5bd915ff7d247588ea497e28c9a568c62db8678d9a5f11515a9a"
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
    url "https://files.pythonhosted.org/packages/d4/08/d8f81287742010e38daf3632380c8d80ede7b4df2716f8ca3d0a2b087d44/filelock-4.2.2.tar.gz"
    sha256 "b29ff2ae9140bb17b3bc77c648dc4f010d9ac0955eccabff4f2b01dde859f787"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b7/89/dfd269de936e76319cf27787d9eaaca513491f635d49b0fbe7cdb6d3bf6f/platformdirs-4.13.4.tar.gz"
    sha256 "dd96496961684a7f42041923f842ec7494e09f5e87aded99117e1109cd40570e"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/9a/c6/04bb77bccfa36aabc783a31e335b5441829f5ec9ff16e313b5b7022d81a8/pyproject_api-1.12.0.tar.gz"
    sha256 "2e83226079dc446a8e2357def7622c01c733284e39afc8e332d9f722fe0c2beb"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/fc/54/fad125f5c48f7821644ee6f223ebfcedc4e23597c1a16eeb13d33aa4a91a/python_discovery-1.6.3.tar.gz"
    sha256 "a62b301d96cf5489cb96ab023b32e068421867fdd5df2e42eece877869047fa2"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/7f/be/4d1d59d309db76b5808fcfd78bd5996f4e7241366691c38fc331a3136398/virtualenv-21.14.11.tar.gz"
    sha256 "593052d8477ea8c55a842387ce111bd08c72618f0c1133c302cafe335e570a57"
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
