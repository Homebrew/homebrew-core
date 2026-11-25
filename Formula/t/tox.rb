class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/ee/da/21b91a62f39b4a9f1a3dca15563d255143b1127416107c445ea9ebcc1289/tox-4.67.16.tar.gz"
  sha256 "5aebaa21a648bb4c129724a2e7aeb4ce951f0d93a37f8709b630719fd5b78ab5"
  license "MIT"

  bottle do
    manifest_sha256 "b37a86b267a584af578bd644d316e73f9dd570effb8e60a7f9f82e000083a082"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b19ef4bb8bc14a8057726056d602375127ec2886bfa035150d1bedbce2b71b21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b19ef4bb8bc14a8057726056d602375127ec2886bfa035150d1bedbce2b71b21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b19ef4bb8bc14a8057726056d602375127ec2886bfa035150d1bedbce2b71b21"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "525dfbb24d6321719461208bf1a9adbf34f1479fa1ef67ee3f4baf59720ff0b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "525dfbb24d6321719461208bf1a9adbf34f1479fa1ef67ee3f4baf59720ff0b2"
  end

  depends_on "python@3.15"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/75/28/eb1ac766e4c0c439506a654186de8e2cfcd99035218a9393986103a0fdf0/cachetools-8.0.2.tar.gz"
    sha256 "30ac523adfc118b51d2b2e7bad8a0ddb31370dfe2700c7f10ca224f36ccf81e0"
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
    url "https://files.pythonhosted.org/packages/e6/86/a5b9ec254b90efb180e390e31a4fa50a93b714d6e4174fa9a4ee25607159/filelock-4.3.1.tar.gz"
    sha256 "4c5ee627c401f1863ac6a0de9a14a28d3bb5f8c730b45e2fd6e5dbc79cf34b9e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/32/e4/a51838ca1b9c6135dc86eda7188e9681a023ecbf684c92e5df59f69deb2f/pyproject_api-1.12.6.tar.gz"
    sha256 "422f037b711cebc650241102a83496aeee6eba088597ce84b58b473760740ad7"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0c/72/8e1d062fa1eed059b49a981394ab3ae26fffea6bbcffa4f7545aa2fb8c4f/python_discovery-1.9.7.tar.gz"
    sha256 "cea89e8a8b86e19731c67f8393f34eb1a2f96c9f97f3e406929a99c646a2358d"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a1/89/e84f19b1a87f70637694494018fdedb395aed90da17872d31e1eb2314d41/virtualenv-21.15.13.tar.gz"
    sha256 "f3ad23551343034e613f9c4d8279f282958a19729f5fc2bcb758afcf95fe3a01"
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
