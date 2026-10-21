class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.6.tar.gz"
  sha256 "20271e220e859b8f60a707597187564d3bda7dbf69dd61aa1357ec1656285246"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "69133210df44133c1ef9309eba4ffd86542119c265fa6b8cce539281c30f6650"
    sha256 arm64_tahoe:       "3785a5c2ae04c6dd6272bb1f8313a0e8c45eb5e3bb2f875f4cb99d890ef6189c"
    sha256 arm64_sequoia:     "1b378d9169ecdf297d9c9c91c6bb131e4f8794458c9d9fd3e2c66b24a2e32516"
    sha256 arm64_linux:       "df04476e1ffce3bf3dddc1d10300de5e5681d31036731cb6577934e701d88964"
    sha256 x86_64_linux:      "a608e850ee24834e59974dac0b4325dbd946a3991ef58cb3172e2e49942afb78"
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
