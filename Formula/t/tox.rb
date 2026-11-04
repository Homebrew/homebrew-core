class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/a9/22/67230af2f6d13c4fada0c3bea05b31bfa813b24dbec9632c000908a1ed2e/tox-4.67.8.tar.gz"
  sha256 "fcfa4d2e168ae37b30ed443b69e39a81736c6ee16389e6ece853ffb1eaa64bcc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3cb7b5aa1891f0298cae9bdee31a552283b77727a5ffbf7f3a64e58959caa208"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3cb7b5aa1891f0298cae9bdee31a552283b77727a5ffbf7f3a64e58959caa208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3cb7b5aa1891f0298cae9bdee31a552283b77727a5ffbf7f3a64e58959caa208"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4eb1a6299bdb47a27e428f302df8cb58d6313b713fbe5abb9528842acafc6454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4eb1a6299bdb47a27e428f302df8cb58d6313b713fbe5abb9528842acafc6454"
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
    url "https://files.pythonhosted.org/packages/e0/14/73688a22e91cfcfc6837a011ffa572e2ba3c348765f7bd482d8436fa9b6f/filelock-4.2.7.tar.gz"
    sha256 "31f6f7e3a8b6f0bd89114d30c5d5218ea1cfb63e5c4aa695b7559314a209bc7f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9a/6e/886dc7c9d21e2d95aceb696f1e31271742033aeef3661f6e9c8921493592/platformdirs-4.14.3.tar.gz"
    sha256 "021add1ab113483edbcd4694f5fbb2d688b893ea30d35e1155bb371cf4be0be8"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/58/f5/a33fb12cca9037a8329f303193a064992e3ddbc5b9ef79e500f8658b9695/pyproject_api-1.12.3.tar.gz"
    sha256 "5bf1f90a915c83831f035cf15998ef98e48e619ff8334fe4dd8110a29aa82af1"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/ea/87/77b17c6d289a551d682826e228e3efa3199305a080541d991cb7b268a527/python_discovery-1.9.2.tar.gz"
    sha256 "de397b9c4b09a5fb8bb4c51db3c0da71fb81d2283718d74fd1efaabffc32afbc"
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
