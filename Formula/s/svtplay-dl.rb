class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/0e/25/fad5ab27c425b4cf2c37bd986999af94b8c922752f0bc21b4ee917112fbe/svtplay-dl-4.69.tar.gz"
  sha256 "baa3dcfabb786b4c883bcebcf9a0406ea5dba25d35e555b0391da8a42883e0f8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b0a5e4b7f0832d2439343f52d8c5617a71e43299512d8f993cd60de4dc186f84"
    sha256 cellar: :any,                 arm64_ventura:  "4c0994817044caffd87b2dccbee8d3af1ef8f044100b1508acfd25ef88563e5c"
    sha256 cellar: :any,                 arm64_monterey: "fa00d80361923c9a3dc37c0e380874d1d81d3249c8ecc2c99d280d14d8a1b76f"
    sha256 cellar: :any,                 sonoma:         "07117ba4743eb6e2bdc922ea7757bd3e386868226adcea7782f8b3584f9863c2"
    sha256 cellar: :any,                 ventura:        "479212d1238b2e509b44b208dcfed4a505ce8bcbab98c7f78498e8f0e80b0e98"
    sha256 cellar: :any,                 monterey:       "2bb9e3571c31bdc724d8a235eb724264425d750fbc057295fe9829ff4bda113f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85ff5a3352fc21bb541207b4bc5a83504a565e04eae2733a5a67a4c82fc6dca7"
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
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
