class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/80/08/c464b63a954f1539cd42e7e8cd6bc61d9de15c37aba4b812e705b1351a94/yle_dl-20250316.tar.gz"
  sha256 "7667a6365fe85140acd3d4378be142ce468e18c5b650d5ed04e3ff5dfd8e946f"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea04e3bf7edbf2f143e8f00b77ad87a928af6c80f458a6a859a8e1f8a831a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8491d1eb4d6f99d4902f17035128a85196b98f5f9bfab010e65f4c01a939e062"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee8721b778801bccd90e87272c0156c16b4790474488b89c8179c06c63afa9b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fe6b29a8f8a909f1e20c562d10d12cadab9000abe85f7804ea7155e1136ef59"
    sha256 cellar: :any_skip_relocation, ventura:       "ea8d60211f01ada6ff57053ef31e0cd6c9a5be8e44b345345dd939a515bd74e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f4e4ec543f127537dacd22d002ba0e3bbeb8da1e1b344c02ff584c6002b94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091cc5cf7736496e1335cf1ca8d8c4822c88c3c25e891c9d166083b5ea9ae751"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.13"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
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

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end
