class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/93/11/d93dd14507c44dd90db8919724255fb763be5a6f4ac475184a1af17357ab/svtplay_dl-4.101.tar.gz"
  sha256 "c4ce423cfc739cdc280df31d13f521a1097a1d03d903afa3251e900c804e8995"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e55e6f1bcd262c7ed76c759877e070f62da7d94cf4d19216342bcd6c9d8d121"
    sha256 cellar: :any,                 arm64_sonoma:  "a5021700d0cd967b57b76e640b562d5c7a5154fa6a9083b8177811b76dfae199"
    sha256 cellar: :any,                 arm64_ventura: "e76c468abf763889eec0e4f0b25bf9bf5ad88ae20e33ac095182de36526c4133"
    sha256 cellar: :any,                 sonoma:        "3b036441fc67101e1ad7a08e1d9d83c9bd061ca67aea05cbaa6d1476893a8d67"
    sha256 cellar: :any,                 ventura:       "6545cf4391374f5fc431a75f1218bfa99d641e41d71e9f341374c4859e7f5b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb9d71db23d8d84ae1e68241dc9abec77a71756b33b35e40d02134d0d5a0c4c8"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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
