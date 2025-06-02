class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/90/dd/c20e5a5bed00ec886ff9bb6a3ff778c807dbe2dad17776ee4ad11040ed40/svtplay_dl-4.113.tar.gz"
  sha256 "953581c6c1d272a5c559d2662ed13d0547910eb9878d4c839a7505e4fbe1ffb4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8bb592d9f261e0371b056b2fddbbd5fc4191f8d8011c79b7c5d5c35ee6657b36"
    sha256 cellar: :any,                 arm64_sonoma:  "ecaad9f0e395dc48c33a676411282f3d08a0ebd91b988fe1709aa023ee3bd6b6"
    sha256 cellar: :any,                 arm64_ventura: "177843710dcb623e889958ecd9158961f4c0f1a05b988941132b499701c89520"
    sha256 cellar: :any,                 sonoma:        "b15705b9c6b947ba34c81313af9c98787f7d0fddd8a80ccfce863241df7913c7"
    sha256 cellar: :any,                 ventura:       "d8435f9b15c376a8d20bc9f6c5db84ef3e3237c89cf113ae7445b52bc2cc6aa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05a7e4045f8804167099623cc9f43f49ef2b6743abe7b2b565dcc29dac29eed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e161a55be2038dd6362610d4799c2f168baee11a5c37f091fe3fa5b2afbc62e"
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
