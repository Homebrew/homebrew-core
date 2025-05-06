class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/71/9b/ce51dda73da3ee3f0c1897d5df46bbd0bcd9377d9002c02631306d92f363/svtplay_dl-4.109.tar.gz"
  sha256 "8b6ed75c58be420616a9616d6cdbfd7039a448be55905fe1331ca13bea23176e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bbb80b6b9e0df5b530608f77a4cc74253f688af74f63991191f1a377b64fd904"
    sha256 cellar: :any,                 arm64_sonoma:  "4d0090fb6a8bb1d898729d7a0a0882a5c228bd53b8f2d0be350c4ba140d94474"
    sha256 cellar: :any,                 arm64_ventura: "d0bcb676130406bf89004d3e90f3f271d9dbc799b1d49a386cb976725deed6e2"
    sha256 cellar: :any,                 sonoma:        "bee93180ee5152a8ddbe82f88dfab50ba019dcf96529a5befef44dfb8edc5e63"
    sha256 cellar: :any,                 ventura:       "3af66a892a5eefb1028992ed82888567339c3d7442146d285689e10a2c81a099"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d62635752da56e37c174e647770fe9d1feddd2d3555ff83ef0cff6e9f7253e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9164e1686f4d3f0f6ebc7012ea01dd123bee0907af9671f028cc4c0dd4acbdfb"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
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
