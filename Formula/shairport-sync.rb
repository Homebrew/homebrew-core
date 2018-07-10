class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.2.tar.gz"
  sha256 "18e9343d4bd8ff70674ff3ecdaf7312dd90e716cac2826a4266c95e08ca305bc"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    sha256 "d1ff0b035918b8a5343d41c8bb880dd192eb1d4b81b42042bdb4f23fcce1dc76" => :high_sierra
    sha256 "f5c880b91dd29c56c30b3fb6867aba05e2775e45b8b91e865382a1cfbe75921a" => :sierra
    sha256 "a566c06a8804ea19d0f65820288f24fbf355495ae6f876a9c69069a89e5465f4" => :el_capitan
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
      --with-os=darwin
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
