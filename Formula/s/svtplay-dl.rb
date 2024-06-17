class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/e9/0c/570d6d9277a2ad144a1d548f0c47c352df3fdb233bec5f5276b249158917/svtplay_dl-4.83.tar.gz"
  sha256 "61cc7475bbca530c90ecf057fbb22bade3dd4d68b7c1636bf6571faf36eab0df"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f4e2939a4916cb3d7cb37c512c2da9fb3f4f99948101fcd373d3980b4a41be97"
    sha256 cellar: :any,                 arm64_ventura:  "1ac86be86b0ff9ff76a2ad9073251179df67314fc817825cbb45a93b93945965"
    sha256 cellar: :any,                 arm64_monterey: "bbd1613adefd160d1d3b300ad1c0807a030acf9711bdf805fa0357e136e19a72"
    sha256 cellar: :any,                 sonoma:         "c84550b9f3a6af09c1dee0fb4536122fb98fcb5064fb4ecdc244584987e5c0af"
    sha256 cellar: :any,                 ventura:        "522fc0d3db0c76ce8c1c6a4901640162c4a2e3862e9e4e740a194be364245161"
    sha256 cellar: :any,                 monterey:       "185da2cc4f2d24d942fd397b7f919cb5a1919cd7892868d0b1ea61c33a68076a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "472644f4fd1c6730efb2cc9668580f43bbfde39cfa2504fe5e912d824c3b8f9e"
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
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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
