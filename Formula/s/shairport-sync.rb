class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/4.3.2.tar.gz"
  sha256 "dfb485c0603398032a00e51f84b874749bbf155b257adda3d270d5989de08bfd"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "8a0b846236e2d90acf2e4d7d200e323ec9e2ef8f675757956a8088f7be499bee"
    sha256 arm64_ventura:  "d7ac35a7d7a96aad49ad3c4be638d3f5710c8a0ee4a351e01399dd233d6556b1"
    sha256 arm64_monterey: "2fa0c6b74bb3d514a44628e5eadfb9e151c4150a29751ea00be9df9b6105919c"
    sha256 sonoma:         "158c27be36e99bb8d1a5478b2fd569cba883f6b045f8ae3ca5bf8caa5771631d"
    sha256 ventura:        "f264ac95675cd0c667c1c4fd08241d808d47b36cf43488d2d2490766a9a7dc65"
    sha256 monterey:       "22d3fce14acd9dbfbf876e4d765bf7c20a1931b064e160d56ca3a38ca2d915df"
    sha256 x86_64_linux:   "7be24efb3ec2c3b1aee23b5cf6022e58e298eb2651e244e07e58caf28c0b6f78"
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
