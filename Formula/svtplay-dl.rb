class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/4c/96/577f1abc02570c9646dcfabe8937361b1a0d6f6eae9a27d6fa8d2b77a124/svtplay-dl-4.14.1.tar.gz"
  sha256 "2f2692199b408820fcac30c965aecb22f37b6d73f17d35115837ed9a34b5cd06"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "604242e0e8a981aab307b83a9b98f29081eb86e389373dd289fc3c001c214e23"
    sha256 cellar: :any,                 arm64_big_sur:  "492a8f39fe5a5e4eda7d94efc78db922adea839e0455ffb9bb627fa9bf9a9e73"
    sha256 cellar: :any,                 monterey:       "c02898e1d6a2907d06fa9f26948952b78b8a350c77a273b42ff9b6e532aeaf81"
    sha256 cellar: :any,                 big_sur:        "298a95f46a7b528b36360a2e59b31a421e9758d66ee0808d114f3d84c7864670"
    sha256 cellar: :any,                 catalina:       "1162442dc5b819cd3a60f8ff31542c6d1f24ed665d80f29c0c97bb94575ed4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa36ae38a139a691bc0d429c8d21aa7501ea9d28bab8388bf1e1cc131818ead7"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/63/82/a6e21842f2e31b3874f01c112093b8bf8af119f5ed999bbd667a81de720b/cryptography-38.0.2.tar.gz"
    sha256 "7a022ec87c7a8bdad99f516a4ee6ffcb3a2bc31487577f9eccbc9b2edb1a8fd4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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
    url = "https://tv.aftonbladet.se/abtv/articles/244248"
    match = "https://amd-ab.akamaized.net/ab/vod/2018/02/cdaefe0533c2561f00a41c52a2d790bd/1280_720_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
