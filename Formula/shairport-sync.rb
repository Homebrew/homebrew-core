class ShairportSync < Formula
  desc "AirTunes emulator. Shairport Sync adds multi-room capability."
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/2.8.3.6.tar.gz"
  sha256 "f59c3bfc2b95af60b822a9729abd94f33330ff81090b00194cf0c999c59133b6"
  head "https://github.com/mikebrady/shairport-sync.git"

  bottle do
    sha256 "88c1b4ef5dca2608facc7f8f1f43a0f81a3db36062b72e82072b2384c2bf5ba0" => :el_capitan
    sha256 "666b3395911138b68def5056fff8c1b0fb29418917b6799c53f67413e073595d" => :yosemite
    sha256 "2c293241a94db289521af9ac3885b351b272b617f9fe4910f147af6368fb4324" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"
  depends_on "popt"
  depends_on "libsoxr"
  depends_on "libao"
  depends_on "libdaemon"
  depends_on "libconfig"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-os-type=darwin
      --with-ssl=openssl
      --with-dns_sd
      --with-ao
      --with-soxr
      --with-configfiles=no
      --with-piddir=#{prefix}
      --prefix=#{prefix}
      --mandir=#{man}
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    test_cmd = "#{bin}/shairport-sync -V"
    assert_match(/openssl-ao-soxr/, shell_output(test_cmd, 1))
  end
end
