class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/6e/71/3187e0915c305605d00736e81523e4a240e66249579e1556a8475d05ba33/tox-4.67.15.tar.gz"
  sha256 "70307cf6cc0a328ca766dc8c20939c697af48d4df2d4bd0c93531eb3be50295d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf4e4707fcdbc6ee1c8f9005dae8f6f3bdbb7566e72557b0e62e82ee33759d3b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf4e4707fcdbc6ee1c8f9005dae8f6f3bdbb7566e72557b0e62e82ee33759d3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf4e4707fcdbc6ee1c8f9005dae8f6f3bdbb7566e72557b0e62e82ee33759d3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bdd69fc4f8b108be0628b0d4af5ebe33123dc878762608b167acf7f29fa68036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bdd69fc4f8b108be0628b0d4af5ebe33123dc878762608b167acf7f29fa68036"
  end

  depends_on "python@3.15"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/06/ce/d7ce62d82ec620e3b08538ce8948f4b3d7cb33829fc274413560004edd6d/cachetools-8.0.1.tar.gz"
    sha256 "deb1d376d4d28c2f33f3e3058043b005e0af75c35c094bd54053e27d2906ad95"
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
    url "https://files.pythonhosted.org/packages/bf/9d/7ec738e68764703d07eb4da4b43aabf0ae6f969f34cb3792a88af400abc5/filelock-4.2.11.tar.gz"
    sha256 "0cb84119fb8dce17898e1f69c974d5019daa59c4d7656be390a5fa59ccced912"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/a6/2c/ec57eede0db493e61443c76ac7b4d24e94a24050afb3d598bf3678487f75/platformdirs-4.14.7.tar.gz"
    sha256 "5472257c1cf97a14658af52997011c7e59e4aebf3a24950b973c11b579e1b074"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/b7/ed/9344d39472a785b6e2c2a204eaf8b064615c8096999988ce660db349b2cc/pyproject_api-1.12.5.tar.gz"
    sha256 "0795693708f631af4c665ab02a315edc0fb97471f1d52e4a6179ed60504e96bb"
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
    url "https://files.pythonhosted.org/packages/7a/04/ead3c46bad2f59ff6d1c6efdf0a1f60ae8565131d2bf920fb579a64c1252/virtualenv-21.15.8.tar.gz"
    sha256 "cfa97e12996373ea030ccbae8eda23cae9cfdbe74aa7b627621b6a0bd03cd7d4"
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
