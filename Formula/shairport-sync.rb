class ShairportSync < Formula
  desc "AirTunes emulator. Shairport Sync adds multi-room capability."
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/2.8.5.tar.gz"
  sha256 "d19f6cd3d53f5010abcf24cc20a301934372b41efc3ff2a2e4e7d8fa49200cdc"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "80d1b7c943952fd4633647dc035be8a7e130f73e7fbcd2cef9ea2e847a10f500" => :el_capitan
    sha256 "2153ee8053718e023fa1321235a583674b40a24ebcd72cbd6599c342095a47ba" => :yosemite
    sha256 "b36d3dff2c4b471edc53731daea183c057b7bec10fe39ae348be0f3849b2f2dd" => :mavericks
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
