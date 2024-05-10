class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/8d/51/3f79faba154f687d1af9c6804b3b836815722cba37df88b0f42c3fcb4282/svtplay-dl-4.71.tar.gz"
  sha256 "44bad803675eef8f6d258f6e8510219ba99ba98967d3f7e23ed48bf081606963"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c56f1df76a1bd9ea619b8f6611da92cd5c21eba74fa40dec0a57acfe96f8e941"
    sha256 cellar: :any,                 arm64_ventura:  "708713b6f1928c20a2bad87ca6d202a40d9c838b6bad4292ad285fdee60dde3a"
    sha256 cellar: :any,                 arm64_monterey: "30f6ea2a660c515e0b16332d50cd34a5ff1f1da6a9bfcd54b99ff89963568139"
    sha256 cellar: :any,                 sonoma:         "7193c9c786ba5831286a1a4306fb98953db898e81590d2bf906d0eb19409126b"
    sha256 cellar: :any,                 ventura:        "a186382547c82a9b00f55df39d10d1797a2ca18e7d83a4ad9a8c9854d1f9233a"
    sha256 cellar: :any,                 monterey:       "83da6faaa33bcec55520be610f59de855dec0e968952f86606b876bdb654af55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9164c46b928d404bf43e157898c3e326b096710c5d9ce5dec9d34ac0c328fa08"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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

  def caveats
    <<~EOS
      To use post-processing options:
        `brew install ffmpeg` or `brew install libav`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/video/357803"
    match = "https://amd-ab.akamaized.net/ab/vod/2023/07/64b249d222f325d618162f76/720_3500_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
