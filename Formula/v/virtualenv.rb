class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/7a/04/ead3c46bad2f59ff6d1c6efdf0a1f60ae8565131d2bf920fb579a64c1252/virtualenv-21.15.8.tar.gz"
  sha256 "cfa97e12996373ea030ccbae8eda23cae9cfdbe74aa7b627621b6a0bd03cd7d4"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "921c78cf2b6fe3b2862211f98493324df8a7f015238ef26d52d5bbebfbe931ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "921c78cf2b6fe3b2862211f98493324df8a7f015238ef26d52d5bbebfbe931ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "921c78cf2b6fe3b2862211f98493324df8a7f015238ef26d52d5bbebfbe931ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3be05a936e302419e5e4e6d3287e15b846e5c0a0faeaf73439aa8824b1028e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f3be05a936e302419e5e4e6d3287e15b846e5c0a0faeaf73439aa8824b1028e0"
  end

  depends_on "python@3.15"

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
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/68/55/70b46fae646bc6f5cb5e82569949d925cff1c7b5ce20ec4a11e0d977f8c6/python_discovery-1.9.5.tar.gz"
    sha256 "86279f5d2728bc067de28b7ddc571be2eacc2ae0e7048f8629d2481a0f8848a2"
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
