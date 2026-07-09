class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/51/96/7f8e6f27fd5aabb9b67aa873483fb33f892f55a6413a33212ae4c29b439c/svtplay_dl-4.191.tar.gz"
  sha256 "4e0fafe29349b08b3c058faaf6a8e31e709613d7a2957ed5269da5c5295a0efb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97dd988cc655ab4952c6ce88ed7ae9473976bd245c0176635da63a2f44021bef"
    sha256 cellar: :any,                 arm64_sequoia: "788b187a66283dc510c11d247e17dca71216de1b784a55aec1a4522650899361"
    sha256 cellar: :any,                 arm64_sonoma:  "c9d259d1b74404e2b9f48917a94b4c8473ffa5af742adba9d5881c26c3f9c6e3"
    sha256 cellar: :any,                 sonoma:        "412d2d81df32f463bb9e24366a13bcd0531718726732d1347ffcf0091e47be6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4ebc9f2c7712edcbfdefbb3a41d2e9d87c631d2758f8787fb3ea45438df6c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca3ac462fcb89c26ff0078269663efaf25f15fa8fc141f2a3c784568370a7293"
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
    url "https://files.pythonhosted.org/packages/1a/88/bcf9709822fe69d02c2a6a77956c98ce6ea8ca8767a9aadcedc7eb6a2390/idna-3.16.tar.gz"
    sha256 "d7a6da03db833450fca25d2358ac9ff06cd624577a4aea3a596d5c0f77b8e03d"
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
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
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
