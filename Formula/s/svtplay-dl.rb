class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/94/34/59ce21f71603d4c04060c322786fe74dc0ed289977634749a586b631cd7c/svtplay-dl-4.28.1.tar.gz"
  sha256 "f2ab208c4568519e2a1260d3fbaeebaeb590222718e52c222ba42f7cc1bae599"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b8213b3c23a72d57b9e5331cf2c4b5607302c06e1f33532e81e689f71c16354"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd72caf905a448d31237984557c4cebf7a0163f531959fca3b693e973ff66fbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fac4e3fda4dd5be2d7c5a6a3d77aa00d2b08d6346b45159df7d8b2d27e979c28"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5a1e202833183596ff797849df034f5e8ad103b3a5812f42e0cd2e935bf3bdf"
    sha256 cellar: :any_skip_relocation, ventura:        "23b5511dd1131e45802802fe4b8bfacfe15652dc834181358fa0a0838ec1d313"
    sha256 cellar: :any_skip_relocation, monterey:       "6d428a3be06e3cc9bcb4a0e021c992361bc3d363ed97ce26fa1fa9081641167f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7205a2068a3341fa4b14e9bf801f3bee27f3585d9982f4c0c8d13d722e487810"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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
