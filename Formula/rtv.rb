class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.14.1.tar.gz"
  sha256 "78650214b4c50f0ba6fd0b79def5d2abd16d14dddbddc67783ffa2b985fdb2ac"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    sha256 "eba31cfce517355d25c338637265a534578c40ada5e57ca8ba111d3c6d118240" => :sierra
    sha256 "3e00d742275527ed9d29619610d0f7be7350ec60574fc29aafba3edcd38df431" => :el_capitan
    sha256 "c3365b9b1a64b8948a99b5494f6adbf045129add36d72570888d1e6011faad88" => :yosemite
  end

  depends_on :python3

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/9b/a5/c6fa2d08e6c671103f9508816588e0fb9cec40444e8e72993f3d4c325936/beautifulsoup4-4.5.3.tar.gz"
    sha256 "b21ca09366fa596043578fd4188b052b46634d22059e68dd0077d9ee77e08a3e"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/13/8a/4eed41e338e8dcc13ca41c94b142d4d20c0de684ee5065523fee406ce76f/decorator-4.0.10.tar.gz"
    sha256 "9c6e98edcb33499881b86ede07d9968c81ab7c769e28e9af24075f0a5379f070"
  end

  resource "kitchen" do
    url "https://files.pythonhosted.org/packages/d7/17/75c460f30b8f964bd5c1ce54e0280ea3ec8830a7c73a35d5036974245b2f/kitchen-1.2.4.tar.gz"
    sha256 "38f73d844532dba7b8cce170e6eb032fc07d0d04a07670e1af754bd4c91dfb3d"
  end

  resource "mailcap-fix" do
    url "https://files.pythonhosted.org/packages/c2/e5/55485018f29af549d94e7a52ce9271ec88ff5f5f2f8246bcc7ce13e3897f/mailcap-fix-1.0.1.tar.gz"
    sha256 "113c0b36091ac0b8181c33f2cd4905280e1bb316383d3c3fcae98c6df094910a"
  end

  resource "praw" do
    url "https://files.pythonhosted.org/packages/84/1b/8e0601a0841089e8d2d86b54a22dae8b53bc8c94bb188f4bab8407206ced/praw-3.6.1.tar.gz"
    sha256 "b36000883533c2f4572fe8810a3b4b245c32b80b7a521211ace8023f40e35997"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5b/0b/34be574b1ec997247796e5d516f3a6b6509c4e064f2885a96ed885ce7579/requests-2.12.4.tar.gz"
    sha256 "ed98431a0631e309bb4b63c81d561c1654822cb103de1ac7b47e45c26be7ae34"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "update_checker" do
    url "https://files.pythonhosted.org/packages/de/17/35d8c5cf206b2840fec39bf33c3817aec0320433f8de574441468a632e99/update_checker-0.16.tar.gz"
    sha256 "70e39446fccf77b21192cf7a8214051fa93a636dc3b5c8b602b589d100a168b8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
