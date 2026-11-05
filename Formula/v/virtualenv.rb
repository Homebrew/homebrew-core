class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/69/74/745e612b69ad14a534b7bc233c4574b968eb2c21a276ea172e8f0fc13f51/virtualenv-21.15.5.tar.gz"
  sha256 "fb869ea32930530ccc87549877b53268c2a4d4a7d7f2c384042eca05170350e6"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45a20dcbccf6c37eca8c2ba4be89da255c96df9cc56c72e410358d7539b3659f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "45a20dcbccf6c37eca8c2ba4be89da255c96df9cc56c72e410358d7539b3659f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45a20dcbccf6c37eca8c2ba4be89da255c96df9cc56c72e410358d7539b3659f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "896697c5196659768d6b96f89d5d76fcd325e34f718ce09a6f76534060936574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "896697c5196659768d6b96f89d5d76fcd325e34f718ce09a6f76534060936574"
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
    url "https://files.pythonhosted.org/packages/0f/d7/1e94df7d1636bf00b9f261bf88a4adc0414f14931ff60511eb0f34c250d1/python_discovery-1.9.4.tar.gz"
    sha256 "c01b45fe515c1d268b57c57d554bb0e1d320b8e9eb5490bb2f4f577be26e4380"
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
