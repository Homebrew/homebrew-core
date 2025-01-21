class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/4.3.5.tar.gz"
  sha256 "66e985e8e51e8e2c5883c95f68063e2b27d81eb372c8f048acf46dd80a94c118"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "8f3939b84f239984967a54546d6cda0bd459b595477c16e61a41607a808717b9"
    sha256 arm64_sonoma:  "7235d516eb91270f4660ef40da9b0fed8ea889108d7c961fc5832513600e49d1"
    sha256 arm64_ventura: "fda3866aa6c18a8ed20602410e011548732bdeefe7a6e8bf4179cd81e33fe625"
    sha256 sonoma:        "b84646e3b2b1fdf4074198d183120817bf61ced0cbad331c02b1c17c956cc0d8"
    sha256 ventura:       "0b589f022ee317d557e27ff0685dbae43c77e7cc7adfed5362d6835ddbae49f3"
    sha256 x86_64_linux:  "42385cd6b41545edc0db16928acf1d7f35c51a172dbe8442206f188ff95ed33c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "pulseaudio"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
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
    ]
    if OS.mac?
      args << "--with-dns_sd" # Enable bonjour
      args << "--with-os=darwin"
    end
    system "./configure", *args, *std_configure_args
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
