class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/90/dd/c20e5a5bed00ec886ff9bb6a3ff778c807dbe2dad17776ee4ad11040ed40/svtplay_dl-4.113.tar.gz"
  sha256 "953581c6c1d272a5c559d2662ed13d0547910eb9878d4c839a7505e4fbe1ffb4"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f64583102f3204aab723fca1608176f59ea3a191a879180396a0a527ca4a5d0e"
    sha256 cellar: :any,                 arm64_sonoma:  "050d44e2e55cdd96531cf7a732ff4f77a7944616dff7a5600d94620ec54190b0"
    sha256 cellar: :any,                 arm64_ventura: "e1acf972470b7570b9d187fe8f7a29cb72aab64636dad1184dc782bed075b182"
    sha256 cellar: :any,                 sonoma:        "93af5984787d5bb2151bbb32cf563443bf079b72dcbf1a820003be1534cfca64"
    sha256 cellar: :any,                 ventura:       "cd1901e7f1494986b47003c4d38a47d38c88f8dc81543d2bf70114800c1b1dea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae8bd052f0d5e2cc3ee8db8a2f7dfe318478bb2518ae501dc8389852b29473d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23acbb3e42de88175b7a8e15b87fda28b2162510f9c11a402c0e0e00dab8aa94"
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
