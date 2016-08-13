class ShairportSync < Formula
  desc "AirTunes emulator. Shairport Sync adds multi-room capability."
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/2.8.4.tar.gz"
  sha256 "80dd94c5f37b43e9b157dd5335f8edaf11109859d0144e0046c7b86fe88f6547"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    revision 1
    sha256 "db6badb38ad81e3b8a884fb6997d45c9895134f530ba30fb0e2a1a3a979044ce" => :el_capitan
    sha256 "7b5b30ab5741b5833f3a170efee2724aa77df233741223895f107b70528d3079" => :yosemite
    sha256 "4da33ef7fb709b02bc147db5484422cf2cb7f1f40f31a11a1cb58c0be7f190d1" => :mavericks
  end

  devel do
    url "https://github.com/mikebrady/shairport-sync/archive/2.8.4.4.tar.gz"
    sha256 "a25e85386b3c0e32de1e01350d835e11414a42b87a136953d2d09e4ed45e1209"
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

  # opened PR 12 Aug 2016: "use sysconfdir not $(DESTDIR)/etc for config files"
  patch do
    url "https://github.com/mikebrady/shairport-sync/pull/355.patch"
    sha256 "1e5909c43f8e2e7c729f6884be121b06cd201220e3159804fd845be412046f9b"
  end

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
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{etc}/shairport-sync
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V", 1)
    assert_match "OpenSSL-ao-stdout-pipe-soxr-metadata", output
  end
end
