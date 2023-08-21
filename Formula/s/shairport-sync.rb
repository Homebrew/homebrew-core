class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/4.2.tar.gz"
  sha256 "649d95eede8b9284b2e8b9c97d18c1c64cffae0a6c75bc4f03e3ae494a3e25b6"
  license "MIT"
  revision 1
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "02af2fdef1c90aff5e30b840d57634287b7909a02b4b2c5f54c63a044c549030"
    sha256 arm64_monterey: "0cfbcf05b63c13426bb961dee8bf9804ce684dfc38f1d27ed43bb9861063f1a3"
    sha256 arm64_big_sur:  "fc6fa4449dff305a72e037805682e41ce4d002ceb965d680b3b2357456a5dacd"
    sha256 ventura:        "b691cf9ace12fdd87ef2cee18d16d51b404432bc9e8bbf8570571da5e9b1731d"
    sha256 monterey:       "eba80c010d90826bad8eb4bf849eb3a9f52cd3718acbe47f7bcdf628127328a2"
    sha256 big_sur:        "5752154c7630d643d76fccee165a09e12ed817cff6014bf4581a72bf2b5af006"
    sha256 x86_64_linux:   "7d4de3b05ac115645ef2dda082508b540d468de7532a9dd6ce09fe326201405f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "pulseaudio"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-libdaemon
      --with-ssl=openssl
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
    if OS.mac?
      args << "--with-dns_sd" # Enable bonjour
      args << "--with-os=darwin"
    end
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  service do
    run [opt_bin/"shairport-sync", "--use-stderr", "--verbose"]
    keep_alive true
    log_path var/"log/shairport-sync.log"
    error_log_path var/"log/shairport-sync.log"
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V")
    if OS.mac?
      assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-metadata", output
    else
      assert_match "OpenSSL-ao-pa-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end
