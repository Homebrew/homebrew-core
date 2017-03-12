class ShairportSync < Formula
  desc "AirTunes emulator. Shairport Sync adds multi-room capability."
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.0.1.tar.gz"
  sha256 "3fbde4f6e7f5cbc7200f782bd9faca25f7e91edf7dd7a3b514cd616e556a1fee"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    sha256 "67340d3935a9186677604b0561afbb6aad4401d205e2c419abddaa13757db279" => :sierra
    sha256 "40a14ea07e4bfd1c2dbad57c763cef1bfa97e29bb2961271ebe4cfc912f75c28" => :el_capitan
    sha256 "b2ad5b0fb789250851331f3de76dc22257ad6ec511354fe6216b970e612575fe" => :yosemite
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
