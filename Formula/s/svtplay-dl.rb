class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/0e/25/fad5ab27c425b4cf2c37bd986999af94b8c922752f0bc21b4ee917112fbe/svtplay-dl-4.69.tar.gz"
  sha256 "baa3dcfabb786b4c883bcebcf9a0406ea5dba25d35e555b0391da8a42883e0f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3379b20dbeeb33cdd594fe09e28a7f08348ca55e3bfab8ece2bb38dc4f850a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f761acc70b129c1baa84305c64b86ede33cf83f67e0b8a67c7859937d06b2c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f171f1a1455867ed0d6c5908432b2a85853f6f707b518279eca0e65278352ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ee8d1a470fa0591e966c9b5aa2a08bce6a982e7b56001a9f80880e0601d42cb"
    sha256 cellar: :any_skip_relocation, ventura:        "75c9b79e76863393b928e5df6471e3638aae58d3244421e2a07e8a0738a0ca68"
    sha256 cellar: :any_skip_relocation, monterey:       "b597fd2c9bfafb8c3ec6ba8437175969a5acc37f9260d2187654d303688311c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "729c967c059e50fd9f3742386792db9369c727476e4e56f2f7106ed9a4a4e356"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"
  depends_on "pyyaml"

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

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
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
