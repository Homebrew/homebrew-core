class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/be/83/969a103b00d7075e3f76b197f63edcca4b10c2e65000c4d48cef31a8c5c0/RBTools-2.0.1.tar.gz"
  sha256 "df8d5e834ad291c6e743907e27e50fc2f6006cdc6b8a4f9035acc86b87dcba31"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca6d136337a4d895e9d333aa65ab9ae70cf218950a2e236f26c466ba1d926a21"
    sha256 cellar: :any_skip_relocation, big_sur:       "e133d75d705c8d4ce84ced1ecbd790d9364f9e2fadbed907e3800b8cf0a37742"
    sha256 cellar: :any_skip_relocation, catalina:      "0f188ab6170680509af56eb3c35acc9caa58362189336f58b33488f096f5b372"
    sha256 cellar: :any_skip_relocation, mojave:        "13551bbfc8f9307821306832b2f7858b95c6c8bd77c90a6eeafefe66d0f0f2a7"
  end

  depends_on "python@3.9"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/d5/78/dbc2a5eab57a01fedaf975f2c16f04e76f09336dbeadb9994258aa0a2b1a/texttable-1.6.4.tar.gz"
    sha256 "42ee7b9e15f7b225747c3fa08f43c5d6c83bc899f80ff9bae9319334824076e9"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/dd/78f7e080d3bfc87fc19bed54513b430659d38efb2d9ea6e3ad815a665a02/tqdm-4.61.2.tar.gz"
    sha256 "8bb94db0d4468fea27d004a0f1d1c02da3cdedc00fe491c0de986b76a04d6b0a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "#{bin}/rbt", "setup-repo", "--server", "https://demo.reviewboard.org"
    out = shell_output("#{bin}/rbt clear-cache")
    assert_match "Cleared cache in", out
  end
end
