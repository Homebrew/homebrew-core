class ShairportSync < Formula
  desc "AirTunes emulator. Shairport Sync adds multi-room capability."
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/2.8.6.tar.gz"
  sha256 "2e73416ac8fdda1657034afaa143f1710852ebed06e0aa43dafc2b7dc5eb653d"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "8612b9e2c786c0a8c0ef8e54b728d28e59ce0bb10e2b16f2d5ba812d85f21503" => :sierra
    sha256 "09eda0a3e96817e6ed5296fca323dc2ee9acfae4e149eaa950f9ea0b64fe6d05" => :el_capitan
    sha256 "3d3c5332e755d80b1173f9a27d442846a56aa285d597bcc1dd60bda9e971afdc" => :yosemite
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
