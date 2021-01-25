class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/10/1f/bd60d2fd57b626b3ed44daabb6392ee8e1a9d9cb35fc637d9056c4b9d318/RBTools-2.0.tar.gz"
  sha256 "be1bc05e07cc1d2a12382a999855fcdb77f4043f6a8eb802dded1ea698196845"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e133d75d705c8d4ce84ced1ecbd790d9364f9e2fadbed907e3800b8cf0a37742" => :big_sur
    sha256 "ca6d136337a4d895e9d333aa65ab9ae70cf218950a2e236f26c466ba1d926a21" => :arm64_big_sur
    sha256 "0f188ab6170680509af56eb3c35acc9caa58362189336f58b33488f096f5b372" => :catalina
    sha256 "13551bbfc8f9307821306832b2f7858b95c6c8bd77c90a6eeafefe66d0f0f2a7" => :mojave
  end

  depends_on "python@3.9"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/f5/be/716342325d6d6e05608e3a10e15f192f3723e454a25ce14bc9b9d1332772/texttable-1.6.3.tar.gz"
    sha256 "ce0faf21aa77d806bbff22b107cc22cce68dc9438f97a2df32c93e9afa4ce436"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3a/76/467422c5a0157c92a8b8e1ffe14411443682e2951e6f6dde3748e47b31ba/tqdm-4.54.0.tar.gz"
    sha256 "5c0d04e06ccc0da1bd3fa5ae4550effcce42fcad947b4a6cafa77bdc9b09ff22"
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
