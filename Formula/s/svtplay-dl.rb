class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/c5/2a/331900fe1a333853053e2e22e1159a7c08f5d75a0977cbac11a27825f533/svtplay_dl-4.127.tar.gz"
  sha256 "3fcb2b30b9ca11b8c82e6495cc4afb9ba9d5eb6203e2a48e5be1c4c392c50baf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "110e4e83f5525bcce62e9233cdb2031c473ba2b3bc8ef13b7c87b51e9662a754"
    sha256 cellar: :any,                 arm64_sonoma:  "6fac900b8b4a32136af1a475b11bf927bab1a7cbf893504602882392d81b0c6f"
    sha256 cellar: :any,                 arm64_ventura: "ecd3d0a541ff35c40c478de6dec90a9a582c4a2d8ebf2d20bb7f075d51553540"
    sha256 cellar: :any,                 sonoma:        "e081d679ffcb66711e9a12d31436a0339e1920740f38accc28b58bd61713ae16"
    sha256 cellar: :any,                 ventura:       "49d059be505810c027a7063417fc51f0c6033d046051b1dedde6876c47e1cb68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5097818e9c19e92dd4fd2df0f812ad4eff2ed7a1228edb0bf1cafa1a457f126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0283672d0ec76927be8aaaa9992408263632bec6fc38f8b931b75d762b75311b"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
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
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
