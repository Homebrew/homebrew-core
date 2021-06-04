class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/7c/46/4d4c37b6d96eb06961f8b2f38f7df12bb1a4951ff1145ac5dead9977e674/virtualenv-20.4.7.tar.gz"
  sha256 "14fdf849f80dbb29a4eb6caa9875d476ee2a5cf76a5f5415fa2f1606010ab467"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1f691389e7674a57173b4fe228a53355300aeb63ebc56b5a5600f38324c5e4a6"
    sha256 cellar: :any_skip_relocation, big_sur:       "71b72ed55b7c24e18ae6a6cce2e3696421e86932d6e98f1570ed30dd10a84d53"
    sha256 cellar: :any_skip_relocation, catalina:      "d5bbab08495a5df01a4d20c38016c664d3c53e7008f7b0ff0f365726a5bc3364"
    sha256 cellar: :any_skip_relocation, mojave:        "cb5d78013036c2f4c3b68fa9b5022d66062ac71ee5ff90b01967809327b55f7a"
  end

  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/2f/83/1eba07997b8ba58d92b3e51445d5bf36f9fba9cb8166bcae99b9c3464841/distlib-0.3.1.zip"
    sha256 "edf6116872c863e1aa9d5bb7cb5e05a022c519a4594dc703843343a9ddd9bff1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
