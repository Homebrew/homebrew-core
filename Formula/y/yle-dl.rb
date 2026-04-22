class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/a1/92/f2c10d7390899c9f26e08102143d9c0a8d375a7d7a7314e17913ddfa162e/yle_dl-20250730.tar.gz"
  sha256 "2122741f515d5829eff28b2f6b96c251f4f7434412ea6c3ca60e526e60563c89"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41f0a2c2f33c444b5b89372348d3c16803b476ba4f29cb1d9dd8973363c77a79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6d665ecd959cec4d83c8ccdcbadc42369d8534ebe92f70e5d2fcd301b544bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e12d90d05fcfeec54ceb00a8922b605997e3aa9c618eab16eecca0300b18edb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7656e00a766fc9909c173214f2cdc604c0d884ee25ac7085d3255e5682ee1bbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aafc53e6de9c44c1790f948052aa36d38968de432c779f9aa9af21700fc8b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ec90957b43fbe58906a46a5dc18e2eb2ff1c6b8b68589d5dbc65cc9af6b415"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.14"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/3f/0b/30328302903c55218ffc5199646d0e9d28348ff26c02ba77b2ffc58d294a/configargparse-1.7.5.tar.gz"
    sha256 "e3f9a7bb6be34d66b2e3c4a2f58e3045f8dfae47b0dc039f87bcfaa0f193fb0f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
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
