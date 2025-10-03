class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/93/ac/f1c6b39f274dcfa3e01afeb2770a934cc51eb56ea6543dca6b00bb56b2b7/svtplay_dl-4.137.tar.gz"
  sha256 "874a0fa5f1c42c10bf55815c41c1d3ee0ede21c64f8694b12b05a57fd9070a49"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed63c68748505fae76730469f50f225d25b224b456fc6323e8cce0bbb263eabd"
    sha256 cellar: :any,                 arm64_sequoia: "19d026776b4915a970bc54c236ba6855e2a38b8bab0bb0eebef8b23e3a562b82"
    sha256 cellar: :any,                 arm64_sonoma:  "d14832c0752834769c7751deedf3f8a7a25b35690603942a558202f4a37aa642"
    sha256 cellar: :any,                 sonoma:        "558f233cdbf920ef9f7c1cde9e5c89a98faa4fcbb4dad37fca4fa5502ea4acb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cefcc8b34012b72d57025d32ff365e96c4ee6018bddb1434756f1dd63061aba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "410898cd16085b3c4722130c59669dc15ac639a2c60fa879ee996e2ee22e9011"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
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
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
