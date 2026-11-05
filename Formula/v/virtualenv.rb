class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/13/f3/08c61662e52a519eabd535148c7545705bab3e7954f1219d49083cdedbf0/virtualenv-21.15.3.tar.gz"
  sha256 "cb83a84cedda6509c93ea5b381c3b5ecec666f7b500d34566503f5bfdc87f498"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "087fc1310fe14580d1962d2ff59afcc040b10d4c73437fa13bd521f770488b60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "087fc1310fe14580d1962d2ff59afcc040b10d4c73437fa13bd521f770488b60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "087fc1310fe14580d1962d2ff59afcc040b10d4c73437fa13bd521f770488b60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c4e7548c874d146e5b05302ff6977939f97414a115927734219e8dbe018667b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c4e7548c874d146e5b05302ff6977939f97414a115927734219e8dbe018667b0"
  end

  depends_on "python@3.15"

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

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/ea/87/77b17c6d289a551d682826e228e3efa3199305a080541d991cb7b268a527/python_discovery-1.9.2.tar.gz"
    sha256 "de397b9c4b09a5fb8bb4c51db3c0da71fb81d2283718d74fd1efaabffc32afbc"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
