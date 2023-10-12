class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/55/43/fadb1a9af21d5fc6dc2f98494a0bdf21fb3a13715bd11bd608dcf1d687e9/svtplay-dl-4.28.tar.gz"
  sha256 "928e1fc3148e849a286e43ddbbcc5a6c202f8b29df777f48b9ad02548dfc24dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d722ec15eac96137a1583029338338d329c73c9968000edc094e05b0993dc5dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "296a29525c2df18e850e05f945e7c84c6a5e35768bdebacbe7dbd8fdc81ab223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fb10a1ac39a8a9a253447b6980560fb5538c662a9e2bc4519a1993b6646242c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e04466f3fc47f73e66eceece4b8c6a9dee5d70f47626b13bf6d2054f4c41e7e"
    sha256 cellar: :any_skip_relocation, ventura:        "b103e280d54f0bdc3e75cdb9fc393829bcc647bec8e47607b63e5635ddd0619c"
    sha256 cellar: :any_skip_relocation, monterey:       "df745d294950ede45f0df75fa8b6ef26c3da244f7cdbc48914fe5da6dd638f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "240dd3989dbacbb3e10af95883db2aa8f6b621ec59bfa1f82b6357d427c03ee0"
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
