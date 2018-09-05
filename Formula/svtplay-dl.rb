class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/bb/be/1306d71f18f5734b3ea5d0fe17492b42f81ae5d0d19682a05741b7858459/svtplay-dl-2.0.tar.gz"
  sha256 "3234ba78c86f5049d59435931ba2e21d4195a46eb68e4cafc9750fc223c85a27"

  bottle do
    cellar :any_skip_relocation
    sha256 "96aa59529a974f5d0c771b9ad50120489e1be90bcf6d8a9e07f58f0a81eea03b" => :mojave
    sha256 "9f090e7ce1ee778440d61006dba57b3a058b085f69485004804beab550887615" => :high_sierra
    sha256 "d5105e033b738d80c8ece2d47cf0628a8bb04855a7a392a787c68cb957541771" => :sierra
    sha256 "85d7bb2d9674c45dc6c3605b44dd361a80ea0c9553d1ac5311f9fde63e7515ad" => :el_capitan
  end

  depends_on "openssl"
  depends_on "python"
  depends_on "rtmpdump"

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/94/7f/33b748dd22ea889fcb1a6c6f1f30ad1e5a70066cd7615dbce7d9a6392106/pycryptodome-3.6.6.tar.gz"
    sha256 "b3cb4af317d9b84f6df50f0cfa6840ba69556af637a83fd971537823e13d601a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e1/0f/f8d5e939184547b3bdc6128551b831a62832713aa98c2ccdf8c47ecc7f17/certifi-2018.8.24.tar.gz"
    sha256 "376690d6f16d32f9d1fe8932551d80b23e9d393a8578c5633a2ed39a64861638"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/53/12/6bf1d764f128636cef7408e8156b7235b150ea31650d0260969215bb8e7d/PySocks-1.6.8.tar.gz"
    sha256 "3fe52c55890a248676fd69dc9e3c4e811718b777834bcaab7a8125cf9deac672"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/54/1f/782a5734931ddf2e1494e4cd615a51ff98e1879cbe9eecbdfeaf09aa75e9/requests-2.19.1.tar.gz"
    sha256 "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/3c/d2/dc5471622bd200db1cd9319e02e71bc655e9ea27b8e0ce65fc69de0dac15/urllib3-1.23.tar.gz"
    sha256 "a68ac5e15e76e7e5dd2b8f94007233e01effe3e50e8daddf69acfd81cb686baf"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats; <<~EOS
    To use post-processing options:
      `brew install ffmpeg` or `brew install libav`.
  EOS
  end

  test do
    url = "https://tv.aftonbladet.se/abtv/articles/244248"
    match = <<~EOS
      https://absvpvod-vh.akamaihd.net/i/2018/02/cdaefe0533c2561f00a41c52a2d790bd
      /,1280_720_2800,960_540_1500,640_360_800,480_270_300,.mp4.csmil
      /index_0_av.m3u8
    EOS
    assert_match match.delete!("\n"), shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
