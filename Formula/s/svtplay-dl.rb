class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/69/7f/5a513d0a4cbf405ecb4657df6e268798d2cbcb9fac51b3a931d88061d330/svtplay_dl-4.97.1.tar.gz"
  sha256 "06164cf8b7f146bbd8cfdf4263d2c150e42caa39f5d7c4ced0116a40004b12aa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "13b5b955556305e4a194c067d9cef78a3fca2b9d814b014f765fe53e90d513b4"
    sha256 cellar: :any,                 arm64_ventura:  "db0a356f9eefeaf546201d71432766a440796bd00e8f19fe7013aa71ae6ff2a6"
    sha256 cellar: :any,                 arm64_monterey: "d2a60b903622d13a37e5057725cd420a37d2cfba7ec809f4003aeec646baa3d4"
    sha256 cellar: :any,                 sonoma:         "d6b425d3b6a62d4fd68fb881edd5f20f8eb5da4b7a3cf3132548f824e7daf1ff"
    sha256 cellar: :any,                 ventura:        "ef9a7b964f7878957d95d4b11a7b266fa7a5e155cd3096fcabcc8da1ba542c2c"
    sha256 cellar: :any,                 monterey:       "09fc160ec000325997e1a3cd6c944890a947422e9b03f520dd796c58c6ad9cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722a7ee1850147ab01fe06162f81e6cee76a618236a468fb3c178c78fcae9a9f"
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
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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
