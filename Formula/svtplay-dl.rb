class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/ba/ef/fffb99eec8aa8b8eaa989dbb5158a55f3cb0adccdde5c05e1708bb22cb7f/svtplay-dl-1.9.11.tar.gz"
  sha256 "3ece5ba28cbdf65490169b8c13fa17b2ba531e7b9a8137f0700b569cbd8e21c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "08152f1fa8a69f00d1ab5395ff56c2acd95158dd510c9a9466d3c91fe587dcb5" => :high_sierra
    sha256 "1459efa77e0c4ba52ca8be3f24457f32f25933311d8aebe365340381a170d46b" => :sierra
    sha256 "689675a28ef799324c2ca527ff70a089251314d42a2a0c7b7ee6e1b050da56dd" => :el_capitan
  end

  # The dependencies differ for Python <= 2.7.9.
  # Mavericks ships Python 2.7.5; Yosemite, 2.7.10.
  depends_on "python@2" if MacOS.version <= :mavericks

  depends_on "rtmpdump"
  depends_on "openssl"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/15/d4/2f888fc463d516ff7bf2379a4e9a552fef7f22a94147655d9b1097108248/certifi-2018.1.18.tar.gz"
    sha256 "edbc3f203427eef571f79a7692bb160a2b0f7ccaa31953e99bd17e307cf63f7d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/53/12/6bf1d764f128636cef7408e8156b7235b150ea31650d0260969215bb8e7d/PySocks-1.6.8.tar.gz"
    sha256 "3fe52c55890a248676fd69dc9e3c4e811718b777834bcaab7a8125cf9deac672"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  def install
    if MacOS.version <= :mavericks
      ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"
    end

    virtualenv_install_with_resources
  end

  def caveats; <<~EOS
    To use post-processing options:
      `brew install ffmpeg` or `brew install libav`.
  EOS
  end

  test do
    url = "https://tv.aftonbladet.se/abtv/articles/244248"
    assert_match "m3u8", shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
