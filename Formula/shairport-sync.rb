class ShairportSync < Formula
  desc "AirTunes emulator. Shairport Sync adds multi-room capability."
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/2.8.4.tar.gz"
  sha256 "80dd94c5f37b43e9b157dd5335f8edaf11109859d0144e0046c7b86fe88f6547"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "80d1b7c943952fd4633647dc035be8a7e130f73e7fbcd2cef9ea2e847a10f500" => :el_capitan
    sha256 "2153ee8053718e023fa1321235a583674b40a24ebcd72cbd6599c342095a47ba" => :yosemite
    sha256 "b36d3dff2c4b471edc53731daea183c057b7bec10fe39ae348be0f3849b2f2dd" => :mavericks
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
