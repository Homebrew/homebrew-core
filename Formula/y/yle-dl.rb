class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/34/40/2f3a90f891a32a16929fcca7099e874ebb0af4dfc5c06309e309d5198f65/yle_dl-20230611.tar.gz"
  sha256 "b6e26d95f5a748bb82126058b548b6515798815967fde24ffe933585a4411df6"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe5878e876eee0427be18c147b4b18884492fccd3910470c7ca6e3d1cce06ec5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db52740ef524b8897ea78be86b92a53ab7ad7e076d240c9c7482b8e69552e699"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "793c9b35fca618c66aa6bb2cfc8814591f09381b67d018bd3b8e29ed6e8d0dc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "87f2e70f53b0505f20ecd429cd7f0348f5c2dce48a137c90476e438cbe853f03"
    sha256 cellar: :any_skip_relocation, ventura:        "b6b5c096a5ce4c36857fc887a89c5731e974c762520aeeca7a0564c4280fca1e"
    sha256 cellar: :any_skip_relocation, monterey:       "5736e454a114d8bd3f7131159ddb0cedaf6b9cf62f90a4a0aa0c34e9b39c6ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e283d0ef4c41765d3f2a0c756e25f9df8d14db19bc82249e3af1085884a336d"
  end

  depends_on "cffi"
  depends_on "ffmpeg"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-lxml"
  depends_on "python@3.12"
  depends_on "rtmpdump"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/a0/19/dfb42dd6e6749c6e6dde55b12ee44b3c8247c3cfa5b85180a60902722538/xattr-0.10.1.tar.gz"
    sha256 "c12e7d81ffaa0605b3ac8c22c2994a8e18a9cf1c59287a1b7722a2289c952ec5"
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
