class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/4d/6a/60344980cdb6e40e93608ed81f31a844773cda5d3e90aa1e84f05308b54a/yle_dl-20240429.tar.gz"
  sha256 "d1618505c41916f8620ae5704939b0a127dd653bc91afb20d0e6183e342cdb7c"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00c638afa77a5396203bc872a9ac2162c59082df4f219d70034f6ed074872985"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4b30a6f478479db651ab76dd7d95b95a201e7c62d17a110a19ae09199c02a10"
    sha256 cellar: :any,                 arm64_monterey: "4394424723e5d44809fdfaa90b272e433e15e0163c3ce21fa8bdccae3895b77c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6f5d7f8164d8b92ed49010e43227d39d596d0d1178bdf6dd434499264abb8f1"
    sha256 cellar: :any_skip_relocation, ventura:        "3fb7757424337c567da72e7478a71334e601af7630ef05d3b1089e08b33e55a4"
    sha256 cellar: :any,                 monterey:       "1470e97892c4ba198df6da6e0711af57466cd5a12cb49354f7de46556375889c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "604fb1965cce0e2aa823d265f97f7b7ce75a5e212911fe6a64e4f84aaa87feaf"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.12"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end
