class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/b3/bd/e40ad2df6a9efc1f859ea23d63fd7371cff68252833f182ca9af819bb4d3/virtualenv-21.15.6.tar.gz"
  sha256 "c8b65c7d206ca6ef18de9352c160b3f04f66fff9f6b0ec8fd31f14688eba52c4"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ea4a2549bb278fcc050ddfff21337643d53f8effa94b9776cc0530da6b79bf8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ea4a2549bb278fcc050ddfff21337643d53f8effa94b9776cc0530da6b79bf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ea4a2549bb278fcc050ddfff21337643d53f8effa94b9776cc0530da6b79bf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fff7a143f2dde6d049b6cc7698ace8d34634f918f611e51dd949ce33bd447206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fff7a143f2dde6d049b6cc7698ace8d34634f918f611e51dd949ce33bd447206"
  end

  depends_on "python@3.15"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/a3/1d/d730c664fcb4f1d264a722722a3134cf0881854f73c1fd58abf87572f232/filelock-4.2.9.tar.gz"
    sha256 "96530b7c538d4ea08493ab067247aab7948c54d8cd622cce711c97cccc5d9896"
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
