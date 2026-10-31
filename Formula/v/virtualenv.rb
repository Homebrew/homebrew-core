class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/38/9e/40c7098240cedd3a2f32e42a74b35c4563c617fdd7e41ae6268d4fdd8915/virtualenv-21.15.2.tar.gz"
  sha256 "dbd886e6e5689eb4dde6a9bbc478ad14b4fc8ed0852690d8273ccfb8c467f635"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "405a6fca0d4c34999f759969c7db095a59b6496db3f9d983b028b72c2d944e1f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "405a6fca0d4c34999f759969c7db095a59b6496db3f9d983b028b72c2d944e1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "405a6fca0d4c34999f759969c7db095a59b6496db3f9d983b028b72c2d944e1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f96d31d140888247adce334fe119a0299cc35916a378bb0b3a76be0af2acdeaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f96d31d140888247adce334fe119a0299cc35916a378bb0b3a76be0af2acdeaa"
  end

  depends_on "python@3.15"

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

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/91/53/f0382313b138502c5af4d3f534db0a5f0925d628d110be2fc42fb38fb0d5/python_discovery-1.7.0.tar.gz"
    sha256 "f484668953706f0b8815521ccf13811fa6ccdc4bd68cf3ef943594ad68a2ac86"
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
