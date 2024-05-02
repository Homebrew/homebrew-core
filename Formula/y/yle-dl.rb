class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/4d/6a/60344980cdb6e40e93608ed81f31a844773cda5d3e90aa1e84f05308b54a/yle_dl-20240429.tar.gz"
  sha256 "d1618505c41916f8620ae5704939b0a127dd653bc91afb20d0e6183e342cdb7c"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c120749f8b64b00bd0da28cd1da7e2cd8e9bb776e387d405af84009be46dbdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39f0577189db0bd07a438ebe2d55dcd8375cf9f4ccab93e146186588c376491b"
    sha256 cellar: :any,                 arm64_monterey: "43764eb5fe187b1b29b7b7f34e23e49e1a711d7f20e0b07c967009edf62b93c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1d5ccafab705eb283cf0349e7590d72cfb5614852249c531a80fae6192648ed"
    sha256 cellar: :any_skip_relocation, ventura:        "fbad7c6b6bc557d1027fbdf139c8d103f28cf0357f4e7dd7ea8f96b11e8d8e48"
    sha256 cellar: :any,                 monterey:       "92b1f6f25f8993466e219d5c636e390806b889f872c5ae454a7b6aec8bcd19f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2addb8a019f40544a282746f6fc9715242d55956af4e7ee90dc115ca54dfc79"
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
    url "https://files.pythonhosted.org/packages/ea/e2/3834472e7f18801e67a3cd6f3c203a5456d6f7f903cfb9a990e62098a2f3/lxml-5.2.1.tar.gz"
    sha256 "3f7765e69bbce0906a7c74d5fe46d2c7a7596147318dbc08e4a2431f3060e306"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
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
