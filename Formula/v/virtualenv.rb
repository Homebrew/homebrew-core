class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/ae/66/8dd793701fa14a32086a7b7c3acaa7c22d8de6a7359b34eb7467d2d00c51/virtualenv-21.15.9.tar.gz"
  sha256 "adc6799981f513ce852aea17ea592e0d342ce48e87f5d17a3d997966df582a67"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8db480d2544e7275adfc01e0f5492ae15aa87e9955d6287c1b6c25fc6b345acb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8db480d2544e7275adfc01e0f5492ae15aa87e9955d6287c1b6c25fc6b345acb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8db480d2544e7275adfc01e0f5492ae15aa87e9955d6287c1b6c25fc6b345acb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d7d6e869458032e69ed079777588ca9c938e637081b146eae1e3a5cf0b42c51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d7d6e869458032e69ed079777588ca9c938e637081b146eae1e3a5cf0b42c51e"
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
    url "https://files.pythonhosted.org/packages/a6/2c/ec57eede0db493e61443c76ac7b4d24e94a24050afb3d598bf3678487f75/platformdirs-4.14.7.tar.gz"
    sha256 "5472257c1cf97a14658af52997011c7e59e4aebf3a24950b973c11b579e1b074"
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
