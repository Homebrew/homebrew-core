class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/e0/c3/7f507928cfbe7de639fde0118190ab17dcb8a6da83f921032859a922a5ec/virtualenv-21.15.12.tar.gz"
  sha256 "a3976f886eb6019fcb1d137b223d160adaeff524ab0ad785c729a43c31cc158c"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    manifest_sha256 "854ff73d8a0cb195c4352ff8c5715124cdfd30ab508ae77c6c380b69e0d805fc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ef7cdaf8e37002eaa41349bdddd183021baf73e26cef74ba13c19206789f12b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ef7cdaf8e37002eaa41349bdddd183021baf73e26cef74ba13c19206789f12b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ef7cdaf8e37002eaa41349bdddd183021baf73e26cef74ba13c19206789f12b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0f9f4999b7f979c88a99e17214226ce0f862ab5c9be6d1439634b07f4219dc23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0f9f4999b7f979c88a99e17214226ce0f862ab5c9be6d1439634b07f4219dc23"
  end

  depends_on "python@3.15"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/52/aa/8ccff8da9a27e089727fcffd3c5b61708383217e47eb1e1b8af37b1dd166/filelock-4.2.12.tar.gz"
    sha256 "7e7da24d3ac39268b0f156e56870001de44886318f092f9d851e692f7114d6dd"
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
    url "https://files.pythonhosted.org/packages/cb/4e/20a9c45c4bb839e6e03e5971a546c623d12f950aa496cf344dc8e9f07167/python_discovery-1.9.6.tar.gz"
    sha256 "383aa67858d73a9585a843a37a4383c6be98e4d86a981a031328e393a6eb2632"
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
