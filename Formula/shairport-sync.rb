class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.3.4.tar.gz"
  sha256 "420089ed165372bc4ff8878d434db2b703d9559a4624227b7abef501375f9eb7"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    sha256 "5985728eb209ad46587ae175758932e7ff07fd7efdd68db0f428283f217f5607" => :catalina
    sha256 "650b4b15cdd7ec954050a0e07fc350ef3403938931b7d13312aab8a0fcc4772b" => :mojave
    sha256 "af5ab8d96178c59d01d19c1ae49e89a34ca67160b9a0529cff6953c94618b7db" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "pulseaudio"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-os=darwin
      --with-libdaemon
      --with-ssl=openssl
      --with-dns_sd
      --with-ao
      --with-stdout
      --with-pa
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
    output = shell_output("#{bin}/shairport-sync -V")
    assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-metadata", output
  end
end
