class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.6.3.tar.gz"
  sha256 "670f9cefdb9c2d70f7df71890e63ab0a31d08a815dd0734245d935bfd01e766e"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "1c6e782e75cae4c5f47dbc00564f8d10c8945daa13ac83b0739e033e38835ea1"
    sha256 arm64_tahoe:       "59b5f65ade32834412bb4dd038c6992a79088eb86a2b11cf7f3c5a86f6527785"
    sha256 arm64_sequoia:     "cbcc031ea1f48bc872619bfa6e8593782fdd7ebfe208c94d8436b5d6129db036"
    sha256 arm64_linux:       "6dd9285cd8253f95895fdf3d9b06f73980c5548cf081f4c63ed396ce03935638"
    sha256 x86_64_linux:      "40c64395716e98a9ab7c5e42c7313703a06adb2040a603b362e16adc7888b93c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@4"
  depends_on "popt"
  depends_on "pulseaudio"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    args = %W[
      --with-libdaemon
      --with-ssl=openssl
      --with-ao
      --with-stdout
      --with-pulseaudio
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{pkgetc}
    ]
    if OS.mac?
      args << "--with-dns_sd" # Enable bonjour
      args << "--with-os=darwin"
    end
    system "./configure", *args, *std_configure_args
    system "make", "install"

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
      assert_match "libdaemon-OpenSSL-dns_sd-ao-PulseAudio-stdout-pipe-soxr-metadata", output
    else
      assert_match "OpenSSL-ao-PulseAudio-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end
