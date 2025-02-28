class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/f6/db/84bfa8573e8cb9e7ef9a00b56d0080c7def4464abef2e4297c218613cbff/svtplay_dl-4.103.tar.gz"
  sha256 "61a2ce59513deeea3f1d350bd776ab56fda0f8d31bb6ee16180eeda31fd5df54"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb4c2bafbf80e49f5b1dc83c643fabc1a00af919dabe1ce5a4c6aa640599b893"
    sha256 cellar: :any,                 arm64_sonoma:  "249966b449acbf86ce25faf583c0a679e66fa4c3f6d103526a1311662ed08e50"
    sha256 cellar: :any,                 arm64_ventura: "b1ea35d29f9a29abb292eb8bddc30ec6d3abf5f84b52f3913306d298ee8a571d"
    sha256 cellar: :any,                 sonoma:        "d60e213b65b80e7fa0024080b05b9993267cad18df623789a9212bd353ceaaef"
    sha256 cellar: :any,                 ventura:       "0154aecfa3a98ab2c413e04a43171ba91dd3b076318042c98a47aa3b601837f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b4ccbdfee43524455e53d10b2cb4886555c44d8fe086ef2ce5cb4b56f2aa4a"
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
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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
