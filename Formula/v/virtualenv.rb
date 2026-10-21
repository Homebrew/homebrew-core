class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/7f/be/4d1d59d309db76b5808fcfd78bd5996f4e7241366691c38fc331a3136398/virtualenv-21.14.11.tar.gz"
  sha256 "593052d8477ea8c55a842387ce111bd08c72618f0c1133c302cafe335e570a57"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc5a13ae8a0c2ea7f2243bfc78b8976db492b77c7f4f8c5131a7ddb6c7ff3720"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc5a13ae8a0c2ea7f2243bfc78b8976db492b77c7f4f8c5131a7ddb6c7ff3720"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bc5a13ae8a0c2ea7f2243bfc78b8976db492b77c7f4f8c5131a7ddb6c7ff3720"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "22e636a9f1021f23adfde7ee69d7a53f5fe041c133bbee1a77d141afa3bbcb20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "22e636a9f1021f23adfde7ee69d7a53f5fe041c133bbee1a77d141afa3bbcb20"
  end

  depends_on "python@3.15"

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

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/fc/54/fad125f5c48f7821644ee6f223ebfcedc4e23597c1a16eeb13d33aa4a91a/python_discovery-1.6.3.tar.gz"
    sha256 "a62b301d96cf5489cb96ab023b32e068421867fdd5df2e42eece877869047fa2"
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
