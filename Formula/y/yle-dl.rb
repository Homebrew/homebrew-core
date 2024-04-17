class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/5c/ba/ae9008b208cfc78f8de4b32ea98d4107d6bf940e5062f8985f70dd18b086/yle_dl-20240130.tar.gz"
  sha256 "fe871fe3d63c232183f52d234f3e54afa2cffa8aa697a94197d2d3947b19e37d"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f35902567259d37155f4825d425d5a21547a996ec2156291cfb03b5928b0679"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2eb14de25d0914b90adce2ec2d812c3a530f7a0e387b0b432aa10dd920c8cb9e"
    sha256 cellar: :any,                 arm64_monterey: "49109556400bc1ec4b848e130d7cce65b15c43aeee18e83e8f4950650ef27172"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c6283a6dfe95e567e820f39d64bd9e3e57cf105abfbd1e79f663b6d6e5ef8da"
    sha256 cellar: :any_skip_relocation, ventura:        "c8adb70d51554371f67dd81d01477f76448abf68dca9103d450406159f6f095a"
    sha256 cellar: :any,                 monterey:       "47eb7510f15e61ddf95982bb9a7ea2f0f48a62cea971be7f7a8db0c52433bf77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4eb4549b34a3d75596db6e7c9cbfc3b6535554c79c3bafb2805985e5e36899c"
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
