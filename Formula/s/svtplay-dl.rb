class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/1a/8c/90512575319191b2f29540680f827c201b254aa88d1419dd5c4829e27345/svtplay_dl-4.179.tar.gz"
  sha256 "2906e7cc2a62720db30189df39713e67945bdca7b1bdb3a074bfa444cf6f688d"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fb13b49c2550abb361d03967bae7aec55d539ec64d8d6e774dbe0f8478096405"
    sha256 cellar: :any,                 arm64_sequoia: "d889bbc97f3d37c5f8401d92b9875ee56a1ad3f7181f85136216a67cd9c24485"
    sha256 cellar: :any,                 arm64_sonoma:  "c06e0e9d9e53e87e16dc49edd68e19142f3555718afed9ed918ea696757b99c7"
    sha256 cellar: :any,                 sonoma:        "367e59d375646382d88bdaf8570cc8d3251b023b240e1dc0c33f74fcbcc9abfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70cee9111a417daf5b8fd9c13f054523249349b6cf880d9c85f528099f42630d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17d47a491f38d9eeee0b778c95344f5a02a8002837a1a6a65b40be0e3079c40c"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/43/b8/7a707d60fea4c49094e40262cc0e2ca6c768cca21587e34d3f705afec47e/requests-2.34.0.tar.gz"
    sha256 "7d62fe92f50eb82c529b0916bb445afa1531a566fc8f35ffdc64446e771b856a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To use post-processing:
        `brew install ffmpeg`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/video/357803"
    match = "https://amd-ab.akamaized.net/ab/vod/2023/07/64b249d222f325d618162f76/720_3500_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
