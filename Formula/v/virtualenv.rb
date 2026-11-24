class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/a1/89/e84f19b1a87f70637694494018fdedb395aed90da17872d31e1eb2314d41/virtualenv-21.15.13.tar.gz"
  sha256 "f3ad23551343034e613f9c4d8279f282958a19729f5fc2bcb758afcf95fe3a01"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    manifest_sha256 "bceca085b1ea6d9cac719a8dda7790c95c25952f169098561b63b5c495e2eb4b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "239c128c1f5276a358b613540487abd991f0bbf4f13c075c06e554c0bb7b4ff8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "239c128c1f5276a358b613540487abd991f0bbf4f13c075c06e554c0bb7b4ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "239c128c1f5276a358b613540487abd991f0bbf4f13c075c06e554c0bb7b4ff8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "468fb9b6cc70f3eb427d2833275b297191bf04bf30ab22fe68691d9d756f5725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "468fb9b6cc70f3eb427d2833275b297191bf04bf30ab22fe68691d9d756f5725"
  end

  depends_on "python@3.15"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e6/86/a5b9ec254b90efb180e390e31a4fa50a93b714d6e4174fa9a4ee25607159/filelock-4.3.1.tar.gz"
    sha256 "4c5ee627c401f1863ac6a0de9a14a28d3bb5f8c730b45e2fd6e5dbc79cf34b9e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0c/72/8e1d062fa1eed059b49a981394ab3ae26fffea6bbcffa4f7545aa2fb8c4f/python_discovery-1.9.7.tar.gz"
    sha256 "cea89e8a8b86e19731c67f8393f34eb1a2f96c9f97f3e406929a99c646a2358d"
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
