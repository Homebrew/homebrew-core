class UcspiTcp < Formula
  desc "Tools for building TCP client-server applications"
  homepage "https://cr.yp.to/ucspi-tcp.html"
  url "https://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz"
  sha256 "4a0615cab74886f5b4f7e8fd32933a07b955536a3476d74ea087a3ea66a23e9c"
  license :public_domain

  livecheck do
    url "https://cr.yp.to/ucspi-tcp/install.html"
    regex(/href=.*?ucspi-tcp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d1e6c8483d5cc332f7a227ecfe6dcab0392f2d4cbbe33e144dd1c2650d89a86b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "08361b13bd495c563f6340c7cf4aecabf43475f00a3e47116295de56a014c8cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afe836f6e29e826d8e00da8a7f81909b65ebf51e18d3aa9d15709f991d28e5b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "283ab40c4100a1eba330dbb5392d4b88cf224acabfadda051a5040947da685fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1936ea190d3606211cbe6808e3a1d811662145cdf993900ef55730f62fb5daa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f12aad8b88657b73fa01910b07d03d0e2af44d2c4a14ed833acb25bfe1d55f6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0dc01e7228b408a7e4f3b7f4b00854901b4bfebe7a0c7bbe4144acdafebbf06"
    sha256 cellar: :any_skip_relocation, ventura:        "eebce9e4176167e4464bb3f411b786a32fe520c37dc7d070af949927337543de"
    sha256 cellar: :any_skip_relocation, monterey:       "4253dce5cb7114f47612bb7d84f9aeb61fca1da1d7afed62cfb00b4924811eb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6e117599fbdb3619aa5bbc6dbc0dad76b73c507cab9fcf90b4e258b3a3ffb9f"
    sha256 cellar: :any_skip_relocation, catalina:       "7daae5b06fc2d2d42c1fcfc02368bf84e565d0557de006c14c2a31cc91cd25ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "92866f7a65abdf24cf7d3cf1ef62ca038c7d8b8df368b0da9463e305c3c615c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1403c13191ec33d523a407bcac88d15d712598e39629a265890805527bb2a566"
  end

  # IPv6 patch
  # Used to be https://www.fefe.de/ucspi/ucspi-tcp-0.88-ipv6.diff19.bz2
  patch do
    url "https://raw.githubusercontent.com/homebrew/patches/2b3e4da/ucspi-tcp/patch-0.88-ipv6.diff"
    sha256 "c2d6ce17c87397253f298cc28499da873efe23afe97e855bdcf34ae66374036a"
  end

  def install
    # Fix compile with newer Clang
    inreplace "conf-cc", "gcc -O2", "gcc -O2 -Wno-implicit-function-declaration -Wno-implicit-int"

    # Work around build error from root requirement: "Oops. Your getgroups() returned 0,
    # and setgroups() failed; this means that I can't reliably do my shsgr test. Please
    # either ``make'' as root or ``make'' while you're in one or more supplementary groups."
    inreplace "Makefile", "( cat warn-shsgr; exit 1 )", "cat warn-shsgr" if OS.linux?

    (buildpath/"conf-home").unlink
    (buildpath/"conf-home").write prefix

    system "make"
    bin.mkpath
    system "make", "setup"
    share.install prefix/"man"
  end

  test do
    assert_match(/usage: tcpserver/,
      shell_output("#{bin}/tcpserver 2>&1", 100))
  end
end
