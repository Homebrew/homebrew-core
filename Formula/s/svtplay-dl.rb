class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/6d/67/11d664a155856ca12c3db4782288ea44c2ccb18793a8a58ab4b855bd267e/svtplay-dl-4.25.tar.gz"
  sha256 "c6d0166ff059ee18017241bee5d7343be52cfc6e12939513ae26fdf5ad55508e"
  license "MIT"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3556dabf73bdd8b4033788ab18a90dd1f15ba3e4872887e27e4723595f05897a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "627a68708597f6fe8f71510f148976abf6b6546fb1240e734d542755ac76581f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0b7153a9c6ee58b8d0e41fdceabf9e03a39d2c38e44347fe3c3dd78084a0688"
    sha256 cellar: :any_skip_relocation, ventura:        "80760363a1bee78f62d2a9f125d3b74a71a293776ecb131e289cf21e1983422c"
    sha256 cellar: :any_skip_relocation, monterey:       "561803dc76bd866b78e01428fed6971585c38f12ebcb521034218126ff90fa43"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ee393b08f40d5be7ed378b937690f5279e52b869f489fec87e2b5a5280b897c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b99d0e88d268b75d56ef76dfd5ecc9deaa4e788bcd0df7cc48237fafc86841f6"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
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
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
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
