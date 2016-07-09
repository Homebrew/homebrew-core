class ShairportSync < Formula
  desc "AirTunes emulator. Shairport Sync adds multi-room capability."
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/2.8.3.6.tar.gz"
  sha256 "f59c3bfc2b95af60b822a9729abd94f33330ff81090b00194cf0c999c59133b6"
  head "https://github.com/mikebrady/shairport-sync.git"

  bottle do
    revision 1
    sha256 "db6badb38ad81e3b8a884fb6997d45c9895134f530ba30fb0e2a1a3a979044ce" => :el_capitan
    sha256 "7b5b30ab5741b5833f3a170efee2724aa77df233741223895f107b70528d3079" => :yosemite
    sha256 "4da33ef7fb709b02bc147db5484422cf2cb7f1f40f31a11a1cb58c0be7f190d1" => :mavericks
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
      --with-stdout
      --with-pipe
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
    assert_match(/openssl-ao-stdout-pipe-soxr/, shell_output(test_cmd, 1))
  end
end
