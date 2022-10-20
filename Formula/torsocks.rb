class Torsocks < Formula
  desc "Use SOCKS-friendly applications with Tor"
  homepage "https://gitlab.torproject.org/tpo/core/torsocks"
  url "https://gitlab.torproject.org/tpo/core/torsocks/-/archive/v2.4.0/torsocks-v2.4.0.tar.bz2"
  sha256 "54b2e3255b697fb69bb92388376419bcef1f94d511da3980f9ed5cd8a41df3a8"
  head "https://gitlab.torproject.org/tpo/core/torsocks.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "2cabbbb8642a786a45cb99e1633447ceab14b5df439679f8588814ecb3117aab"
    sha256 arm64_big_sur:  "8c1b04d704074ee39b0ad3ff78ffa87ce8bd58ddac3eb6fbb20f559f0bbac55f"
    sha256 monterey:       "65b106a97660e2d27779dca77bf2998df798f4376bc00fd7ba21cbe9ae3f3b26"
    sha256 big_sur:        "3ccf568b46201f651f12d017b6a507f51150cc5f714ad70e3a456e41fe737b7c"
    sha256 catalina:       "2e4214a024055b73d0c6f7f7a05c24d872940b4a49735ed2856711c58e37f2b4"
    sha256 x86_64_linux:   "b2dd5e3cb19d877cb6bb46d58c8c71a03fdc02d1d7bdc7772bc75431df861283"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # https://gitlab.torproject.org/legacy/trac/-/issues/28538
  patch do
    url "https://gitlab.torproject.org/legacy/trac/uploads/9efc1c0c47b3950aa91e886b01f7e87d/0001-Fix-macros-for-accept4-2.patch"
    sha256 "97881f0b59b3512acc4acb58a0d6dfc840d7633ead2f400fad70dda9b2ba30b0"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/torsocks", "--help"
  end
end
