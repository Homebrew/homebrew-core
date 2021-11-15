class UcspiTcp < Formula
  desc "Tools for building TCP client-server applications"
  homepage "https://cr.yp.to/ucspi-tcp.html"
  url "https://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz"
  sha256 "4a0615cab74886f5b4f7e8fd32933a07b955536a3476d74ea087a3ea66a23e9c"

  livecheck do
    url "https://cr.yp.to/ucspi-tcp/install.html"
    regex(/href=.*?ucspi-tcp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1936ea190d3606211cbe6808e3a1d811662145cdf993900ef55730f62fb5daa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f12aad8b88657b73fa01910b07d03d0e2af44d2c4a14ed833acb25bfe1d55f6b"
    sha256 cellar: :any_skip_relocation, monterey:       "4253dce5cb7114f47612bb7d84f9aeb61fca1da1d7afed62cfb00b4924811eb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6e117599fbdb3619aa5bbc6dbc0dad76b73c507cab9fcf90b4e258b3a3ffb9f"
    sha256 cellar: :any_skip_relocation, catalina:       "7daae5b06fc2d2d42c1fcfc02368bf84e565d0557de006c14c2a31cc91cd25ee"
    sha256 cellar: :any_skip_relocation, mojave:         "f464584f762728957020fce03d331fb6e96c79a721cdd5911afb452d4b91da7b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b3f2714c61a157eb31ef53915901c29c24ad3dc5cf7d7c3403dcd501399e26b4"
    sha256 cellar: :any_skip_relocation, sierra:         "46d324e867e5a35cbb17e8a215ff33f693651d11645eed116e4e4a6c02085b34"
    sha256 cellar: :any_skip_relocation, el_capitan:     "a57368e57812063bc4e1450c0bef5cad8392c44e54abf3c8ca950ea51abe7ae9"
    sha256 cellar: :any_skip_relocation, yosemite:       "727e93394b415da772b43ce5028ad54dcb569f695e6c8c4cdf05dc462b2febbe"
  end

  # IPv6 patch
  # Used to be https://www.fefe.de/ucspi/ucspi-tcp-0.88-ipv6.diff19.bz2
  patch do
    url "https://raw.githubusercontent.com/homebrew/patches/2b3e4da/ucspi-tcp/patch-0.88-ipv6.diff"
    sha256 "c2d6ce17c87397253f298cc28499da873efe23afe97e855bdcf34ae66374036a"
  end

  def install
    (buildpath/"conf-home").unlink
    (buildpath/"conf-home").write prefix

    system "make"
    bin.mkpath
    system "make", "setup"
    system "make", "check"
    share.install prefix/"man"
  end

  test do
    assert_match(/usage: tcpserver/,
      shell_output("#{bin}/tcpserver 2>&1", 100))
  end
end
